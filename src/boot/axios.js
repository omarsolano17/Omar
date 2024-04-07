import { boot } from "quasar/wrappers";
import axios from "axios";
import { Notify } from "quasar";
import { useSeguridadStore } from "src/stores/seguridad";
import { useAppStore } from "src/stores/app";

// Be careful when using SSR for cross-request state pollution
// due to creating a Singleton instance here;
// If any client changes this (global) instance, it might be a
// good idea to move this instance creation inside of the
// "export default () => {}" function below (which runs individually
// for each client)
// const api = axios.create({ baseURL: 'https://api.example.com' })
const api = axios.create({ baseURL: JSON.parse(process.env.BASE_URL) });

// #region interceptar las Respuestas
api.interceptors.response.use(
  (response) => {
    // Your Interceptor code to do something with the response data
    // Return response data
    if (response && response.data) {
      const store = useSeguridadStore();
      if (response.data.jwt) {
        store.setJWT(response.data.jwt);
      } else {
        if (response.data.logout === true) {
          store.setJWT(null);
        }
      }
    }

    let ok = false;
    if (response.data.result?.recordset) {
      response.data.result.recordset.forEach((el) => {
        ok = el.OK === "OK";
      });
      if (!ok) {
        if (response.data.result.recordsets.length > 1) {
          if (response.data.result.recordsets[1].length > 0) {
            const errores = response.data.result.recordsets[1];
            if (errores.length > 0) {
              const appStore = useAppStore();
              appStore.setErrores(errores);
            }
          }
        }
      }
    }

    return response;
  },
  (error) => {
    // Your Interceptor code to do something with response error
    // #region Error
    if (error.response) {
      if (error.response.status === 401) {
        Notify.create({
          color: "info",
          icon: "info",
          message: "Session expired",
          position: "top-right",
          textColor: "white",
          actions: [{ icon: "close", color: "white" }],
          timeout: 60000,
        });
      } else if (error.response.status === 404) {
        Notify.create({
          color: "negative",
          icon: "error",
          message: `El servidor web responsable de aceptar las peticiones a la URL (${error.response.config.url}) no está en funcionamiento o hay problemas de conexión ó la URL se enlazó de forma incorrecta`,
          position: "top-right",
          textColor: "white",
          actions: [{ icon: "close", color: "white" }],
          timeout: 60000,
        });
      } else if (error.response.status === 500) {
        console.log("error.response: ", error.response);
        let errorCode = null;
        try {
          if (!errorCode && error.response.data.originalError.code) {
            errorCode = error.response.data.originalError.code;
          }
          if (!errorCode && error.response.status) {
            errorCode = error.response.status;
          }
          if (!errorCode && error.response.data.error.code) {
            errorCode = error.response.data.error.code;
          }
          if (!errorCode && error.response.data.error.code) {
            errorCode = 500;
          }
        } catch (ex) {
          errorCode = 500;
        }
        let errorMessage = null;
        try {
          if (
            error.response &&
            error.response.data &&
            error.response.data.error &&
            error.response.data.error.originalError &&
            error.response.data.error.originalError.info &&
            error.response.data.error.originalError.info.message
          ) {
            errorMessage = error.response.data.error.originalError.info.message;
          }
          if (
            !errorMessage &&
            error.response &&
            error.response.data &&
            error.response.data.error &&
            error.response.data.error.originalError &&
            error.response.data.error.originalError.message
          ) {
            errorMessage = error.response.data.error.originalError.message;
          }
          if (
            !errorMessage &&
            error.response &&
            error.response.data &&
            error.response.data.error
          ) {
            errorMessage = error.response.data.error;
          }
          if (!errorMessage && error.response.statusText) {
            errorMessage = error.response.statusText;
          }
          if (!errorMessage && error.response.data.originalError.message) {
            errorMessage = error.response.data.originalError.message;
          }
          if (!errorMessage && error.response.data) {
            errorMessage = error.response.data;
          }
          if (
            !errorMessage &&
            error.response.data.error.originalError.info.message
          ) {
            errorMessage = error.response.data.error.originalError.info.message;
          }
        } catch (ex) {
          errorMessage = undefined;
        }

        if (!errorMessage) {
          errorMessage =
            (error.response.data.error.originalError
              ? error.response.data.error.originalError.message
              : undefined) ||
            error.response.data.error.message ||
            error.response.data.error ||
            error.response.data.error.originalError.info.message;
        }

        Notify.create({
          color: "negative",
          icon: "error",
          message: `Error en el servidor ([${errorCode}] - ${errorMessage})`,
          position: "top-right",
          textColor: "white",
          actions: [{ icon: "close", color: "white" }],
          timeout: 60000,
        });
      } else {
        if (
          (error.response.data.success === false &&
            error.response.data.message) ||
          error.response.data.error
        ) {
          Notify.create({
            color: "negative",
            icon: "error",
            message: error.response.data.message || error.response.data.error,
            position: "top-right",
            textColor: "white",
            actions: [{ icon: "close", color: "white" }],
            timeout: 60000,
          });
        } else {
          Notify.create({
            color: "negative",
            icon: "error",
            message: error.response,
            position: "top-right",
            textColor: "white",
            actions: [{ icon: "close", color: "white" }],
            timeout: 60000,
          });
        }
      }
    } else if (error.request) {
      Notify.create({
        progress: true,
        color: "negative",
        icon: "error",
        message:
          "Conexión demorada ó no hay conexión a internet. No ha habido una respuesta rápida, vuelva a intentarlo.",
        position: "top-right",
        textColor: "white",
        actions: [{ icon: "close", color: "white" }],
        timeout: 60000,
      });
    } else {
      Notify.create({
        color: "negative",
        icon: "error",
        message: `Unexpected error: ${error}`,
        position: "top-right",
        textColor: "white",
        actions: [{ icon: "close", color: "white" }],
        timeout: 60000,
      });
    }

    // #endregion

    return Promise.reject(error);
  }
);
export default boot(({ app }) => {
  // for use inside Vue files (Options API) through this.$axios and this.$api

  // app.config.globalProperties.$axios = axios;
  // // ^ ^ ^ this will allow you to use this.$axios (for Vue Options API form)
  // //       so you won't necessarily have to import axios in each vue file

  // app.config.globalProperties.$api = api;
  // ^ ^ ^ this will allow you to use this.$api (for Vue Options API form)
  //       so you can easily perform requests against your app's API

  api.interceptors.request.use(function (config) {
    if (process.env.DEBUGGING) {
      console.log(config.url);
    }
    if (!config.headers.Authorization) {
      const seguridadStore = useSeguridadStore();
      if (seguridadStore.jwt) {
        config.headers.Authorization =
          "Bearer " + JSON.parse(JSON.stringify(seguridadStore.jwt));
      }
    }
    config.headers.Expires = "-1";
    return config;
  });
});

export { api };

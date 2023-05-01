export function useFechas(){

  const getFechaCorta = (value) => {
    if (!value) return "";
    value = value.toString();
    const [d] = value.split("T");
    const [yyyy, mm, dd] = d.split("-");

    return `${dd}/${mm}/${yyyy}`;
  }
  const getFechaCortaGringa = (value)=>{
    if (!value) return ''
    value = value.toString()
    const [d] = value.split('T')
    const [yyyy, mm, dd] = d.split('-')

    return `${yyyy}-${mm}-${dd}` // .charAt(0).toUpperCase() + value.slice(1)
  }
  const getFechaLarga = (value) => {
    if (!value) return ''
    value = value.toString()
    const [d, t] = value.split('T')
    const [yyyy, mm, dd] = d.split('-')

    let hora = ''
    if (t.toString().length >= 5) {
      hora = t.toString().substring(0, 5)
    }

    return `${dd}/${mm}/${yyyy} ${hora}` // .charAt(0).toUpperCase() + value.slice(1)
  }
  const getFechaLargaGringa = (value) => {
    if (!value) return ''
    value = value.toString()
    const [d, t] = value.split('T')
    const [yyyy, mm, dd] = d.split('-')

    let hora = ''
    if (t.toString().length >= 5) {
      hora = t.toString().substring(0, 5)
    }

    return `${yyyy}-${mm}-${dd} ${hora}` // .charAt(0).toUpperCase() + value.slice(1)
  }
  const getHora = (value) => {
    if (!value) return ''
    value = value.toString()
    // eslint-disable-next-line
    const [d, t] = value.split('T')
    let hora = ''
    if (t.toString().length >= 5) {
      hora = t.toString().substring(0, 5)
    }

    return `${hora}` // .charAt(0).toUpperCase() + value.slice(1)
  }
  const getPrescripcion = (hcatd, sinDisposicion, soloDosisTotal) => {
    const item = hcatd
    if ((!item.MEDICAMENTO && !item.MEDICAMENTOS) || item.RAZONNEC === 4) {
      delete (item.FRECUENCIA)
      delete (item.DURACION)
    }
  
    let texto = ''
    if (!sinDisposicion) {
      let d = 'Iniciar'
      switch (item.CLASE) {
        case 'I':
          d = 'Iniciar'
          break
        case 'C':
          d = 'Continuar'
          break
        case 'B':
          d = 'Cambiar'
          break
        case 'S':
          d = 'Suspender'
          break
      }
      texto += d + ' '
    }
    if (item.RAZONNEC === 2) {
      let duracion = item.DURACION
      const sufijo = duracion * 1 > 0 ? 's' : ''
      if (!item.TIPODURACION && duracion * 1 > 0) {
        duracion = `${
          item.DURACION * 1 > 24 ? (item.DURACION * 1) / 24 : item.DURACION
          } ${item.DURACION * 1 > 24 ? 'd韆' + sufijo : 'hora' + sufijo}.`
      } else {
        if (item.DURACION * 1 > 0) {
          if (item.PORSUBIR) {
            duracion = ` ${item.DURACION} ${item.TIPODURACION === 'D' ? 'd韆s' : 'horas'}.`
          } else {
            duracion = ` ${
              item.DURACION * 1 > 24
                ? (item.DURACION * 1) / 24
                : item.DURACION
              } ${item.TIPODURACION === 'D' ? 'd韆' : 'hora'}${sufijo}.`
          }
        }
      }
      texto += ` ${item.DESCSERVICIO} >> ${item.CANTIDADAM}${item.PRESUNI} a las ${item.HORAAM} horas y ${item.CANTIDADPM}${item.PRESUNI} a las ${item.HORAPM} horas por ${duracion}`
      if (item.VIA && item.VIA !== 'No Aplica') {
        texto += ` V韆 ${item.VIA}.`
      }
      const dosisTotal = (item.CANTIDADAM + item.CANTIDADPM) * (item.DURACION * 1 > 24 ? (item.DURACION * 1) / 24 : item.DURACION)
      texto += ` Dosis Total: ${dosisTotal} ${item.PRESUNI}.`
      const equicc = item.EQUICC <= 0 ? 1 : item.EQUICC
      let equivalente = dosisTotal / equicc
      equivalente = Math.ceil(equivalente)
      texto += ` Equivale a ${equivalente} unidad${
            equivalente > 1 ? 'es' : ''
            }.`
      if (soloDosisTotal) return equivalente || dosisTotal
      return texto
    }
    texto += `${item.CANTIDAD}`
    if (item.PRESUNI) {
      texto += ` ${item.PRESUNI}`
    } else {
      if (item.IDTIPOCONC) {
        texto += ` ${item.IDTIPOCONC}`
      }
    }
    if (!item.DESCSERVICIO) {
      texto += ` Servicio ${item.IDSERVICIO} no encontrado`
    } else {
      texto += ` ${item.DESCSERVICIO}`
    }
    if (item.MEDICAMENTO && item.MEDICAMENTO * 1 !== 1) return texto
    if (item.MEDICAMENTOS && item.MEDICAMENTOS * 1 !== 1) return texto
  
    if (item.FRECUENCIA * 1 > 0) {
      texto += ` cada ${item.FRECUENCIA} horas`
    }
  
    if (!item.TIPODURACION && item.DURACION * 1 > 0) {
      // alert('')
      texto += ` por ${
        item.DURACION * 1 > 24 ? (item.DURACION * 1) / 24 : item.DURACION
        } ${item.DURACION * 1 > 24 ? 'd韆s' : 'horas'}.`
    } else {
      if (item.DURACION * 1 > 0) {
        if (item.PORSUBIR) {
          texto += ` por ${item.DURACION} ${item.TIPODURACION === 'D' ? 'd韆s' : 'horas'}.`
        } else {
          texto += ` por ${
            item.DURACION * 1 >= 24
              ? (item.DURACION * 1) / 24
              : item.DURACION
            } ${item.TIPODURACION === 'D' || item.DURACION * 1 >= 24 ? `d韆${item.DURACION * 1 > 24 ? 's' : ''}` : 'horas'}.`
        }
      }
    }
    if (item.VIA && item.VIA !== 'No Aplica') {
      texto += ` V韆 ${item.VIA}.`
    }
    if (item.RAZONNEC > -1) {
      switch (item.RAZONNEC) {
        case 1:
          texto += ' por raz髇 necesaria'
          break
        default:
          break
      }
    }
    let dosisTotal = item.CANTIDAD
    let equivalente = null
  
    if (item.RAZONNEC === 1) {
    } else {
      if (item.MEDICAMENTO * 1 === 1 || item.MEDICAMENTOS * 1 === 1) {
        let unidadMedida = item.PRESUNI
        if (
          !unidadMedida ||
          (unidadMedida === '' && item.IDTIPOCONC && item.IDTIPOCONC !== '')
        ) {
          unidadMedida = item.IDTIPOCONC
        }
        if (!unidadMedida || unidadMedida === '') unidadMedida = 'Unidad'
        if (item.PORSUBIR) {
          dosisTotal =
            item.CANTIDAD *
            (item.TIPODURACION === 'D' ? item.DURACION : item.DURACION / 24) *
            (24 / item.FRECUENCIA)
        } else {
          dosisTotal =
            item.CANTIDAD *
            (item.DURACION * 1 >= 24
              ? (item.DURACION * 1) / 24
              : item.DURACION) *
            (24 / item.FRECUENCIA)
        }
        if (isNaN(dosisTotal)) dosisTotal = item.CANTIDAD
        // if (item.RAZONNEC === 4) dosisTotal = item.CANTIDAD
        if (unidadMedida === 'Unidad' && dosisTotal > 1) unidadMedida += 'es'
        texto += ` Dosis Total: ${dosisTotal} ${unidadMedida}.`
        if (
          unidadMedida !== 'Unidades' &&
          (item.MEDICAMENTO === 1 || item.MEDICAMENTOS === 1)
        ) {
          const equicc = item.EQUICC <= 0 ? 1 : item.EQUICC
          equivalente = dosisTotal / equicc
          equivalente = Math.ceil(equivalente)
          texto += ` Equivale a ${equivalente} unidad${
            equivalente > 1 ? 'es' : ''
            }.`
          // texto += ` Equivale a ${dosisTotal / item.EQUICC} unidades.`;
        }
      }
    }
    if (soloDosisTotal) return equivalente || dosisTotal
    return texto
  }
  
  const getPrescripcionEnOrdenes = (hcatd, tipoDuracion, sinDisposicion, soloDosisTotal) => {
    const item = hcatd
    item.TIPODURACION = tipoDuracion
    if ((!item.MEDICAMENTO && !item.MEDICAMENTOS) || item.RAZONNEC === 4) {
      delete (item.FRECUENCIA)
      delete (item.DURACION)
    }
  
    let texto = ''
    if (!sinDisposicion) {
      let d = 'Iniciar'
      switch (item.CLASE) {
        case 'I':
          d = 'Iniciar'
          break
        case 'C':
          d = 'Continuar'
          break
        case 'B':
          d = 'Cambiar'
          break
        case 'S':
          d = 'Suspender'
          break
      }
      texto += d + ' '
    }
    if (item.RAZONNEC === 2) {
      let duracion = item.DURACION
      const sufijo = duracion * 1 > 0 ? 's' : ''
      if (!item.TIPODURACION && duracion * 1 > 0) {
        duracion = `${
          item.DURACION * 1 > 24 ? (item.DURACION * 1) / 24 : item.DURACION
          } ${item.DURACION * 1 > 24 ? 'd韆' + sufijo : 'hora' + sufijo}.`
      } else {
        if (item.DURACION * 1 > 0) {
          duracion = ` ${item.DURACION} ${item.TIPODURACION === 'D' ? 'd韆s' : 'horas'}.`
        }
      }
      texto += ` ${item.DESCSERVICIO} >> ${item.CANTIDADAM}${item.PRESUNI} a las ${item.HORAAM} horas y ${item.CANTIDADPM}${item.PRESUNI} a las ${item.HORAPM} horas por ${duracion}`
      if (item.VIA && item.VIA !== 'No Aplica') {
        texto += ` V韆 ${item.VIA}.`
      }
      const dosisTotal = (item.CANTIDADAM + item.CANTIDADPM) * (item.DURACION * 1 > 24 ? (item.DURACION * 1) / 24 : item.DURACION)
      texto += ` Dosis Total: ${dosisTotal} ${item.PRESUNI}.`
      const equicc = item.EQUICC <= 0 ? 1 : item.EQUICC
      let equivalente = dosisTotal / equicc
      equivalente = Math.ceil(equivalente)
      texto += ` Equivale a ${equivalente} unidad${
            equivalente > 1 ? 'es' : ''
            }.`
      if (soloDosisTotal) return equivalente || dosisTotal
      return texto
    }
    texto += `${item.CANTIDAD}`
    if (item.PRESUNI) {
      texto += ` ${item.PRESUNI}`
    } else {
      if (item.IDTIPOCONC) {
        texto += ` ${item.IDTIPOCONC}`
      }
    }
    if (item.MEDICAMENTO && item.MEDICAMENTO * 1 !== 1) return texto
    if (item.MEDICAMENTOS && item.MEDICAMENTOS * 1 !== 1) return texto
  
    if (item.FRECUENCIA * 1 > 0) {
      texto += ` cada ${item.FRECUENCIA} horas`
    }
  
    if (!item.TIPODURACION && item.DURACION * 1 > 0) {
      texto += ` por ${
        item.DURACION * 1 > 24 ? (item.DURACION * 1) / 24 : item.DURACION
      } ${item.DURACION * 1 > 24 ? 'd韆s' : 'horas'}.`
    } else {
      if (item.DURACION * 1 > 0) {
        texto += ` por ${item.DURACION} ${item.TIPODURACION === 'D' ? 'd韆s' : 'horas'}.`
      }
    }
    if (item.RAZONNEC > -1) {
      switch (item.RAZONNEC) {
        case 1:
          texto += ' por raz髇 necesaria'
          break
        default:
          break
      }
    }
    let dosisTotal = item.CANTIDAD
    let equivalente = null
  
    if (item.RAZONNEC === 1) {
    } else {
      if (item.MEDICAMENTO * 1 === 1 || item.MEDICAMENTOS * 1 === 1) {
        let unidadMedida = item.PRESUNI
        if (
          !unidadMedida ||
          (unidadMedida === '' && item.IDTIPOCONC && item.IDTIPOCONC !== '')
        ) {
          unidadMedida = item.IDTIPOCONC
        }
        if (!unidadMedida || unidadMedida === '') unidadMedida = 'Unidad'
        dosisTotal =
            item.CANTIDAD *
            (item.TIPODURACION === 'D' ? item.DURACION : item.DURACION / 24) *
            (24 / item.FRECUENCIA)
        if (isNaN(dosisTotal)) dosisTotal = item.CANTIDAD
        if (unidadMedida === 'Unidad' && dosisTotal > 1) unidadMedida += 'es'
        texto += ` Dosis Total: ${dosisTotal} ${unidadMedida}.`
        if (
          unidadMedida !== 'Unidades' &&
          (item.MEDICAMENTO === 1 || item.MEDICAMENTOS === 1)
        ) {
          const equicc = item.EQUICC <= 0 ? 1 : item.EQUICC
          equivalente = dosisTotal / equicc
          equivalente = Math.ceil(equivalente)
          texto += ` <span class="text-italic text-negative">Equivale a ${equivalente} unidad${
            equivalente > 1 ? 'es' : ''
            }.</span>`
          // texto += ` Equivale a ${dosisTotal / item.EQUICC} unidades.`;
        }
      }
    }
    if (soloDosisTotal) return equivalente || dosisTotal
    return texto
  }
  return {
    getFechaCorta,
    getFechaCortaGringa,
    getFechaLarga,
    getFechaLargaGringa,
    getHora,
    getPrescripcion,
    getPrescripcionEnOrdenes
  }
}

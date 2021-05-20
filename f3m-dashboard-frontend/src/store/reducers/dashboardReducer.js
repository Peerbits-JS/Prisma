const initState = {
  menu: null,
  dashboarddata: {
    userdata: [],
    shopdata: []
  },
  billing: {
    billingTotalToday: {},
    billingTotalYesterday: {},
    billingTotalCurrentMonth: {},
    billingTotalCurrentYear: {}
  },
  performance: {
    total: {},
    aros: {},
    opthalmicLenses: {},
    contactLenses: {},
    sunGlasses: {},
    several: {}
  },
  chart: {},
  loadapi: {
    isLoadingShops: false,
    isLoadingUsers: false,
    isLoadingBillingtoday: false,
    isLoadingBillingyesterday: false,
    isLoadingBillingmonth: false,
    isLoadingBillingyear: false,
    isLoadingPerfomanceSummary: false,
    isLoadingPerfomancetotal: false,
    isLoadingPerfomancearos: false,
    isLoadingPerfomanceopthalm: false,
    isLoadingPerfomancecontact: false,
    isLoadingPerfomancesunglas: false,
    isLoadingPerfomanceseveral: false,
    isLoadingBarchart: false
  },
  filterPayload: null

}

const dashboardReducer = (state = initState, action) => {

  switch (action.type) {
    case "FILTER_PAYLOAD":
      return {
        ...state,
        filterPayload: action.payload.filterPayload,
      }
    case "FETCH_MENU":
      return {
        ...state,
        menu: action.menu,
      }
    case "LOADING":
      return {
        ...state,
        loadapi: action.payload.loadapi,
      }
    case "FETCH_USERS_DATA":
      return {
        ...state,
        dashboarddata: {
          ...state.dashboarddata,
          userdata: action.payload.dashboarddata.userdata,
        },
        loadapi: {
          ...state.loadapi,
          isLoadingUsers: false
        }
      }
    case "FETCH_SHOPS_DATA":
      return {
        ...state,
        dashboarddata: {
          ...state.dashboarddata,
          shopdata: action.payload.dashboarddata.shopdata
        },
        loadapi: {
          ...state.loadapi,
          isLoadingShops: false
        }
      }
    case "FETCH_BILLINGTOTAL_TODAY":
      return {
        ...state,
        billing: {
          ...state.billing,
          billingTotalToday: action.payload.billing.billingTotalToday
        },
        loadapi: {
          ...state.loadapi,
          isLoadingBillingtoday: false
        }
      }
    case "FETCH_BILLINGTOTAL_YESTERDAY":
      return {
        ...state,
        billing: {
          ...state.billing,
          billingTotalYesterday: action.payload.billing.billingTotalYesterday
        },
        loadapi: {
          ...state.loadapi,
          isLoadingBillingyesterday: false
        }
      }
    case "FETCH_BILLINGTOTAL_CURRENTMONTH":
      return {
        ...state,
        billing: {
          ...state.billing,
          billingTotalCurrentMonth: action.payload.billing.billingTotalCurrentMonth
        },
        loadapi: {
          ...state.loadapi,
          isLoadingBillingmonth: false
        }
      }
    case "FETCH_BILLINGTOTAL_CURRENTYEAR":
      return {
        ...state,
        billing: {
          ...state.billing,
          billingTotalCurrentYear: action.payload.billing.billingTotalCurrentYear
        },
        loadapi: {
          ...state.loadapi,
          isLoadingBillingyear: false
        }
      }
    case "FETCH_PERFOMANCE_SUMMARY":
      return {
        ...state,
        performance: action.payload.performance,
        chart: action.payload.performance.chart,
        loadapi: {
          ...state.loadapi,
          isLoadingPerfomanceSummary: false
        }
      }
    case "FETCH_PERFOMANCE_TOTAL":
      return {
        ...state,
        performance: {
          ...state.performance,
          total: action.payload.performance.total
        },
        loadapi: {
          ...state.loadapi,
          isLoadingPerfomancetotal: false
        }
      }
    case "FETCH_PERFOMANCE_AROS":
      return {
        ...state,
        performance: {
          ...state.performance,
          aros: action.payload.performance.aros
        },
        loadapi: {
          ...state.loadapi,
          isLoadingPerfomancearos: false
        }
      }
    case "FETCH_PERFOMANCE_OPTHALMICLENSES":
      return {
        ...state,
        performance: {
          ...state.performance,
          opthalmicLenses: action.payload.performance.opthalmicLenses
        },
        loadapi: {
          ...state.loadapi,
          isLoadingPerfomanceopthalm: false
        }
      }
    case "FETCH_PERFOMANCE_CONTACTLENSES":
      return {
        ...state,
        performance: {
          ...state.performance,
          contactLenses: action.payload.performance.contactLenses
        },
        loadapi: {
          ...state.loadapi,
          isLoadingPerfomancecontact: false
        }
      }
    case "FETCH_PERFOMANCE_SUNGLASSES":
      return {
        ...state,
        performance: {
          ...state.performance,
          sunGlasses: action.payload.performance.sunGlasses
        },
        loadapi: {
          ...state.loadapi,
          isLoadingPerfomancesunglas: false
        }
      }
    case "FETCH_PERFOMANCE_SEVERAL":
      return {
        ...state,
        performance: {
          ...state.performance,
          several: action.payload.performance.several
        },
        loadapi: {
          ...state.loadapi,
          isLoadingPerfomanceseveral: false
        }
      }
    case "FETCH_CHART_DATA":
      return {
        ...state,
        chart: action.payload.chart,
        loadapi: {
          ...state.loadapi,
          isLoadingBarchart: false
        }
      }
    default:
      return { ...state }
  }
}

export default dashboardReducer

const initState = {
  salesData: {},
}

const salesReducer = (state = initState, action) => {
  
  switch (action.type) {
    
    case "FETCH_SALES_DATA":
      return {
        ...state,
        salesData: action.payload.salesData,
      }
      case "UPDATE_SALES_DATA":
        return {
          ...state,
          salesData: action.payload.salesData,
        }
      case "SAVE_SALES_DATA":
        return {
          ...state,
          salesData: action.payload.salesData,
        }
    default:
      return { ...state }
  }
}

export default salesReducer

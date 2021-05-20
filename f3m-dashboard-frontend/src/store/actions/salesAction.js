import axios from 'axios';
import { getSalesURL, postSalesURL } from './../../api';
import { toast } from 'react-toastify';
//Action createStore

export const loadSales = (year) => async (dispatch) => {
    //FETCH Axios
    const salesData = await axios.post(getSalesURL(year))

    dispatch({
        type: "FETCH_SALES_DATA",
        payload: {
            salesData: salesData.data,
        }
    })
}

export const updateSalesData = (salesData) => async (dispatch) => {
    //FETCH Axios



    dispatch({
        type: "UPDATE_SALES_DATA",
        payload: {
            salesData: {
                shopWiseSales: salesData
            },
        }
    })
}

export const saveSales = (payload) => async (dispatch) => {
    //FETCH Axios
    const salesData = await axios.post(postSalesURL(), payload)

    if (salesData.status == 200) {
        toast.success("Data saved successfully");
    }
    else {
        toast.error("Error ! something went wrong.");
    }

    let UpdatedsalesData = await axios.post(getSalesURL(payload.shopWiseSales[0].year))

    dispatch({
        type: "SAVE_SALES_DATA",
        payload: {
            salesData: UpdatedsalesData.data,
        }
    })
}
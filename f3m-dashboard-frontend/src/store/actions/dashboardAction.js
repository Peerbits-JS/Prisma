import axios from 'axios';
import HeaderService from '../../services/F3M/header-service';
import { encrypt } from '../../shared/helpers/encrypt';

import {
  shopListURL,
  userListURL,
  billingTotalForTodayURL,
  billingTotalForYesterdayURL,
  billingTotalForCurrentMonthURL,
  billingTotalForCurrentYearURL,
  perfomanceTotalURL,
  perfomanceArosURL,
  perfomanceOpthalmicLensesURL,
  perfomanceContactLensesURL,
  perfomanceSunGlassesURL,
  perfomanceseveralURL,
  barChartURL,
  perfomanceSummaryURL
} from './../../api';


//store filter data
export const saveFilter = (payload) => async (dispatch) => {

  await dispatch({
    type: "FILTER_PAYLOAD",
    payload: {
      filterPayload: payload,
    }
  })
}


//Dashoboard actions
export const getMenu = () => async (dispatch) => {
  //FETCH Axios
  if (new URLSearchParams(window.location.href).get('IDMenu') === null) {
    localStorage.setItem('menu', encrypt(JSON.stringify(null)));
    dispatch({
      type: "FETCH_MENU",
      menu: null
    })
    return false;
  }

  const response = await HeaderService.getMenu(new URLSearchParams(window.location.href).get('IDMenu'), 'Dashboard');

  if (response.data !== null && response.data !== undefined) {
    localStorage.setItem('menu', encrypt(JSON.stringify(response.data)));
    dispatch({
      type: "FETCH_MENU",
      menu: response.data
    })
    return true;
  }
  return false;
}

let loadapi = {
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
}

export const loadShops = (payload) => async (dispatch) => {

  loadapi.isLoadingShops = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })

  const response = await axios.post(shopListURL(), payload)

  loadapi.isLoadingShops = false;

  await dispatch({
    type: "FETCH_SHOPS_DATA",
    payload:
    {
      dashboarddata: { shopdata: response.data.shops },
    }
  })
}

export const loadUsers = (payload) => async (dispatch) => {

  loadapi.isLoadingUsers = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })

  const response = await axios.post(userListURL(), payload)

  loadapi.isLoadingUsers = false;

  await dispatch({
    type: "FETCH_USERS_DATA",
    payload:
    {
      dashboarddata: { userdata: response.data.users },
    }
  })
}


// Billing actions

export const loadBillingTotalForToday = (payload) => async (dispatch) => {

  loadapi.isLoadingBillingtoday = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })

  //FETCH Axios
  const response = await axios.post(billingTotalForTodayURL(), payload)

  loadapi.isLoadingBillingtoday = false;

  await dispatch({
    type: "FETCH_BILLINGTOTAL_TODAY",
    payload:
    {
      billing: { billingTotalToday: response.data },
    }
  })
}

export const loadBillingTotalForYesterday = (payload) => async (dispatch) => {

  loadapi.isLoadingBillingyesterday = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })

  //FETCH Axios
  const response = await axios.post(billingTotalForYesterdayURL(), payload)

  loadapi.isLoadingBillingyesterday = false;


  await dispatch({
    type: "FETCH_BILLINGTOTAL_YESTERDAY",
    payload:
    {
      billing: { billingTotalYesterday: response.data },
    }
  })
}

export const loadBillingTotalForMonth = (payload) => async (dispatch) => {

  loadapi.isLoadingBillingmonth = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })


  //FETCH Axios
  const response = await axios.post(billingTotalForCurrentMonthURL(), payload)

  loadapi.isLoadingBillingmonth = false;

  await dispatch({
    type: "FETCH_BILLINGTOTAL_CURRENTMONTH",
    payload:
    {
      billing: { billingTotalCurrentMonth: response.data },
    }
  })
}

export const loadBillingTotalForYear = (payload) => async (dispatch) => {

  loadapi.isLoadingBillingyear = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })

  //FETCH Axios
  const response = await axios.post(billingTotalForCurrentYearURL(), payload)

  loadapi.isLoadingBillingyear = false;

  await dispatch({
    type: "FETCH_BILLINGTOTAL_CURRENTYEAR",
    payload:
    {
      billing: { billingTotalCurrentYear: response.data },
    }
  })
}


// Perfomance actions

export const loadPerfomanceSummary = (payload) => async (dispatch) => {

  loadapi.isLoadingPerfomanceSummary = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })

  const response = await axios.post(perfomanceSummaryURL(), payload)

  loadapi.isLoadingPerfomanceSummary = false;

  await dispatch({
    type: "FETCH_PERFOMANCE_SUMMARY",
    payload:
    {
      performance: response.data,
    }
  })
}

export const loadPerfomamceTotal = (payload) => async (dispatch) => {

  loadapi.isLoadingPerfomancetotal = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })
  //FETCH Axios
  const response = await axios.post(perfomanceTotalURL(), payload)

  loadapi.isLoadingPerfomancetotal = false;

  await dispatch({
    type: "FETCH_PERFOMANCE_TOTAL",
    payload:
    {
      performance: { total: response.data },
    }
  })
}

export const loadPerfomamceAros = (payload) => async (dispatch) => {

  loadapi.isLoadingPerfomancearos = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })
  // //FETCH Axios
  const response = await axios.post(perfomanceArosURL(), payload)

  loadapi.isLoadingPerfomancearos = false;

  await dispatch({
    type: "FETCH_PERFOMANCE_AROS",
    payload:
    {
      performance: { aros: response.data },
    }
  })
}

export const loadPerfomamceOpthalmicLenses = (payload) => async (dispatch) => {

  loadapi.isLoadingPerfomanceopthalm = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })
  //FETCH Axios
  const response = await axios.post(perfomanceOpthalmicLensesURL(), payload)

  loadapi.isLoadingPerfomanceopthalm = false;

  await dispatch({
    type: "FETCH_PERFOMANCE_OPTHALMICLENSES",
    payload:
    {
      performance: { opthalmicLenses: response.data },
    }
  })
}

export const loadPerfomamceContactLenses = (payload) => async (dispatch) => {

  loadapi.isLoadingPerfomancecontact = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })
  //FETCH Axios
  const response = await axios.post(perfomanceContactLensesURL(), payload)

  loadapi.isLoadingPerfomancecontact = false;

  await dispatch({
    type: "FETCH_PERFOMANCE_CONTACTLENSES",
    payload:
    {
      performance: { contactLenses: response.data },
    }
  })
}

export const loadPerfomamceSunGlassesURL = (payload) => async (dispatch) => {

  loadapi.isLoadingPerfomancesunglas = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })
  //FETCH Axios
  const response = await axios.post(perfomanceSunGlassesURL(), payload)

  loadapi.isLoadingPerfomancesunglas = false;

  await dispatch({
    type: "FETCH_PERFOMANCE_SUNGLASSES",
    payload:
    {
      performance: { sunGlasses: response.data },
    }
  })
}

export const loadPerfomamceSeveral = (payload) => async (dispatch) => {

  loadapi.isLoadingPerfomanceseveral = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })
  //FETCH Axios
  const response = await axios.post(perfomanceseveralURL(), payload)

  loadapi.isLoadingPerfomanceseveral = false;

  await dispatch({
    type: "FETCH_PERFOMANCE_SEVERAL",
    payload:
    {
      performance: { several: response.data },
    }
  })
}

// Chart actions

export const loadBarChart = (payload) => async (dispatch) => {
  //FETCH Axios
  loadapi.isLoadingBarchart = true;

  await dispatch({
    type: "LOADING",
    payload: {
      loadapi: loadapi,
    }
  })

  const response = await axios.post(barChartURL(), payload)
  loadapi.isLoadingBarchart = false;

  dispatch({
    type: "FETCH_CHART_DATA",
    payload:
    {
      chart: response.data.chart,
    }
  })
}






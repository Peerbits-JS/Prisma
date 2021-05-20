//Base URL
export const base_url = 'https://localhost:44361/api/';
export const prisma_url = 'http://localhost/Prisma';

// header
export const header = `Header/`;

export const getMenu = header + `GetMenu/:idMenu:`;

export const getFavouriteMenu = header + `GetFavouriteMenu/:idMenu:`;
export const getHomePageMenu = header + `GetHomePageMenu/:idMenu:`;

export const addFavouriteMenu = `/Navegador/AdicionaFavorito`;
export const addHomePageMenu = `/Navegador/AdicionaHomepage`;

export const removeFavouriteMenu = `/Navegador/RemoveFavorito`;
export const removeHomePageMenu = `/Navegador/RemoveHomepage`;

export const getMenuURL = () => `${base_url}${getMenu}`
export const getFavouriteMenuURL = () => `${base_url}${getFavouriteMenu}`
export const getHomePageMenuURL = () => `${base_url}${getHomePageMenu}`

export const addFavouriteMenuURL = () => `${prisma_url}${addFavouriteMenu}`
export const addHomePageMenuURL = () => `${prisma_url}${addHomePageMenu}`

export const removeFavouriteMenuURL = () => `${prisma_url}${removeFavouriteMenu}`
export const removeHomePageMenuURL = () => `${prisma_url}${removeHomePageMenu}`


// Dashboard

export const dashboard = `Dashboard/`;

export const shoplist = dashboard + `GetShopList`;
export const userlist = dashboard + `GetUserList`;

export const shopListURL = () => `${base_url}${shoplist}`
export const userListURL = () => `${base_url}${userlist}`

// Billing

export const billing = `Billing/`;

export const billingTotalForToday = billing + `GetBillingTotalForToday`;
export const billingTotalForYesterday = billing + `GetBillingTotalForYesterday`;
export const billingTotalForCurrentMonth = billing + `GetBillingTotalForCurrentMonth`;
export const billingTotalForCurrentYear = billing + `GetBillingTotalForCurrentYear`;


export const billingTotalForTodayURL = () => `${base_url}${billingTotalForToday}`
export const billingTotalForYesterdayURL = () => `${base_url}${billingTotalForYesterday}`
export const billingTotalForCurrentMonthURL = () => `${base_url}${billingTotalForCurrentMonth}`
export const billingTotalForCurrentYearURL = () => `${base_url}${billingTotalForCurrentYear}`


// Perfomance

export const perfomance = `Performance/`;

export const perfomanceSummary = perfomance + `GetPerformance`;
export const total = perfomance + `GetTotal`;
export const aros = perfomance + `GetAros`;
export const opthalmicLenses = perfomance + `GetOpthalmicLenses`;
export const contactLenses = perfomance + `GetContactLenses`;
export const sunGlasses = perfomance + `GetSunGlasses`;
export const several = perfomance + `GetSeveral`;


export const perfomanceSummaryURL = () => `${base_url}${perfomanceSummary}`
export const perfomanceTotalURL = () => `${base_url}${total}`
export const perfomanceArosURL = () => `${base_url}${aros}`
export const perfomanceOpthalmicLensesURL = () => `${base_url}${opthalmicLenses}`
export const perfomanceContactLensesURL = () => `${base_url}${contactLenses}`
export const perfomanceSunGlassesURL = () => `${base_url}${sunGlasses}`
export const perfomanceseveralURL = () => `${base_url}${several}`

// Chart

export const chart = `Chart/`;

export const barChart = chart + `GetChart`;
export const getsales = chart + `GetSales`;
export const postsales = chart + `PostSales`;

export const barChartURL = () => `${base_url}${barChart}`
export const getSalesURL = (year: number) => `${base_url}${getsales}?year=` + year
export const postSalesURL = () => `${base_url}${postsales}`
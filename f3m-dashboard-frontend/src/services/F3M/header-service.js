import axios from 'axios';
import { isDefined, searchParams } from '../../shared/helpers/utils';
import { serverErrors } from '../../shared/helpers/constants';

import {
    getMenuURL,
    getFavouriteMenuURL,
    getHomePageMenuURL,
    addFavouriteMenuURL,
    removeFavouriteMenuURL,
    addHomePageMenuURL,
    removeHomePageMenuURL,
} from './../../api';


const replace = require('key-value-replace');

/**
 * Handles the pop up that is lauched by a request that doesn´t have access to option
 */
const openPopUpWithoutAccessToOptions = (controllerName) => {
  const tab = searchParams('tab');
  const iframe = window.parent.document.getElementById('F3M_iFrame_F3M_Tab_' + tab);
  const url =  `../Prisma/Dashboard/${controllerName}/Index?link=1&tab=${tab}`;
  
  iframe?.setAttribute('src', url);
};

/**
 * Handles the pop up login that is lauched by a request that has expired cookie
 */
const openPopUpWithLogin = () => {
  eval("window.parent.UtilsDesenhaPopupLogin({},'/F3M/administracao/Autentica/Login?popuplogin=popup', null, null, ['close'], 440, 360, null);");
  eval(`window.parent.UtilsFechaTabAtiva();`);
};

const HeaderService = {

    getMenu: async (idMenu, controllerName) => {
        const endpoint = getMenuURL();
        const url = replace(endpoint,{ idMenu }, [':', ':']);
        
        const response = await axios.get(url).catch(error => {
            return error.response;
        });;

        const serverError =
            !isDefined(response) ||
            response.status === 400 ||
            response.status === 404 ||
            response.status === 415 ||
            response.status === 500 ||
            response.status === 401 ||
            response.status === 403;
        
        const { applicationMessages } = response.data;
    
        if (serverError) {
            if (isDefined(applicationMessages)) {
                let errorKey = applicationMessages[0];

                if(errorKey === serverErrors.SEM_ACESSO_OPCAO_POR_LICENCIAMENTO || errorKey === serverErrors.SEM_AUTENTICACAO || errorKey === serverErrors.SEM_ACESSO_OPCAO)
                    openPopUpWithoutAccessToOptions(controllerName);
                else if(errorKey === serverErrors.COOKIE_EXPIROU)
                    openPopUpWithLogin();
            }
            return null;
        }
    
        return response;
    },
    getFavouriteMenu: async idMenu => {
        const url = replace(getFavouriteMenuURL(),{ idMenu }, [':', ':']);

        const response = await axios.get(url);

        return response.data;
    },
    getHomePageMenu: async idMenu => {
        const url = replace(getHomePageMenuURL(),{ idMenu }, [':', ':']);

        const response = await axios.get(url);

        return response.data;
    },
    addFavouriteMenu: async objFavourite => {
        const response = await axios.post(addFavouriteMenuURL(), objFavourite)

        return response.data;
    },
    removeFavouriteMenu: async inIDOpcao => {
        const response = await axios.post(removeFavouriteMenuURL(), { inIDOpcao })

        return response.data;
    },
    addHomePageMenu: async inIDOpcao => {
        const response = await axios.post(addHomePageMenuURL(), { inIDOpcao })

        return response.data;
    },
    removeHomePageMenu: async inIDOpcao => {
        const response = await axios.post(removeHomePageMenuURL(), { inIDOpcao })

        return response.data;
    },
};

export default HeaderService;
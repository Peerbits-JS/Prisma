import dashboardReducer from './reducers/dashboardReducer';
import salesReducer from './reducers/salesReducer';
import {combineReducers} from 'redux';

const allReducers = combineReducers({
  dashboard: dashboardReducer,
  sales:salesReducer
});

export default allReducers;

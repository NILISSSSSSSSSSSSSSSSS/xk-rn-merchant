import {
    createNavigationReducer,
  } from 'react-navigation-redux-helpers';
import { AppNavigator } from '../Routes';

const navReducer = createNavigationReducer(AppNavigator);
export const navAppReducer = createNavigationReducer(AppNavigator);
export default navReducer;

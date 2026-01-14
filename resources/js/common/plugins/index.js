import moment from "moment";
import './axiosBase';
import './axiosAdmin';
import './axiosFront';

const allModules = window.config.modules;
if (allModules && allModules.length > 0) {
	allModules.forEach((allModule) => {
		try {
			require(`../../../../Modules/${allModule}/Resources/assets/js/plugins`);
		} catch (error) {
			console.warn('Module plugins not found:', allModule);
		}
	});
}

moment.suppressDeprecationWarnings = true;
window.moment = moment;
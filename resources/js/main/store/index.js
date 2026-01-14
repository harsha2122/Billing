import { createStore } from 'vuex';
import auth from './auth';
import front from './front';

const allModules = window.config.modules;
var allModulesStores = {};
if (allModules && allModules.length > 0) {
	allModules.forEach((allModule) => {
		if (allModule) {
			try {
				const moduleStore = require(`../../../../Modules/${allModule}/Resources/assets/js/store/index`).default;

				allModulesStores = { ...allModulesStores, ...moduleStore };
			} catch (error) {
				console.warn('Module store not found:', allModule);
			}
		}
	});
}

export default createStore({
	modules: {
		auth,
		front,
		...allModulesStores
	}
})
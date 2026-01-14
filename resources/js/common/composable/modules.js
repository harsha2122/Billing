import { ref } from "vue";
import axios from "axios";
import { forEach, find, includes, remove } from "lodash-es";
import { notification, message } from "ant-design-vue";
import { useI18n } from "vue-i18n";
import { useStore } from "vuex";
import { getUrlByAppType } from "../scripts/functions";

const modules = () => {
    const allModules = ref([]);
    const rules = ref({});
    const purchaseCode = ref("");
    const errorMessage = ref("");
    const successMessage = ref("");
    const loading = ref(false);
    const { t } = useI18n();
    const productName = ref(window.config.product_name);
    const version = ref(window.config.product_version);
    const store = useStore();
    const offers = ref([]);
    const settings = ref([]);
    const downloading = ref(false);
    const extracting = ref("");
    const downloadPercentage = ref(0);
    var getDownloadTimer;

    const getModuleData = () => {
        const mainProductName = window.config.product_name;

        const modulesPromise = axiosAdmin.get(getUrlByAppType("modules"));
        var allModulesData = [];

        modulesPromise.then((modulesResponse) => {
            const installedModules = window.config.installed_modules;
            const enabledModules = window.config.modules;
            offers.value = [];
            settings.value = {};

            forEach(installedModules, (installedModule) => {
                allModulesData.push({
                    verified_name: installedModule.verified_name,
                    current_version: installedModule.current_version,
                    status: includes(enabledModules, installedModule.verified_name),
                    installed: true,
                    verified: true,
                    other_domain_verified: false,
                    is_free: false,
                });
            });

            allModules.value = allModulesData;
        });
    };

    const verifyPurchase = (configObject) => {
        const { success } = configObject;

        loading.value = true;
        rules.value = {};
        errorMessage.value = "";

        setTimeout(() => {
            loading.value = false;
            notification.success({
                message: t("common.success"),
            });
            successMessage.value = t("messages.verify_success");

            success({ status: "success" });
        }, 500);
    }

    const install = (moduleName) => {
        notification.error({
            message: t("common.error"),
            description: "Module installation is disabled. All modules are already unlocked.",
        });
    }

    const setDownloadPercentage = () => {
        axiosAdmin(getUrlByAppType("modules/download-percentage")).then((response) => {
            downloadPercentage.value = parseInt(response.data.percentage);

            if (downloadPercentage.value >= 100) {
                clearInterval(getDownloadTimer);
            }
        });
    }

    return {
        allModules,
        getModuleData,
        install,

        verifyPurchase,
        rules,
        purchaseCode,
        errorMessage,
        successMessage,
        loading,
        productName,
        version,

        offers,
        settings,
        downloading,
        downloadPercentage,
        extracting,
    };
}

export default modules;

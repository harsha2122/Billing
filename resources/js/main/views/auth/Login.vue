<template>
    <div class="login-main-container">
        <a-row class="main-container-div">
            <a-col :xs="24" :sm="24" :md="24" :lg="8">
                <a-row class="login-left-div">
                    <a-col
                        :xs="{ span: 20, offset: 2 }"
                        :sm="{ span: 20, offset: 2 }"
                        :md="{ span: 16, offset: 4 }"
                        :lg="{ span: 16, offset: 4 }"
                    >
                        <a-card
                            :title="null"
                            class="login-div"
                            :bordered="innerWidth <= 768 ? true : false"
                        >
                            <a-form layout="vertical">
                                <div class="login-logo mb-30" v-if="globalSetting?.light_logo_url">
                                    <img
                                        class="login-img-logo"
                                        :src="globalSetting.light_logo_url"
                                    />
                                </div>
                                <a-alert
                                    v-if="onRequestSend.error != ''"
                                    :message="onRequestSend.error"
                                    type="error"
                                    show-icon
                                    class="mb-20 mt-10"
                                />
                                <a-alert
                                    v-if="onRequestSend.success"
                                    :message="$t('messages.login_success')"
                                    type="success"
                                    show-icon
                                    class="mb-20 mt-10"
                                />

                                <!-- OTP Verification Step -->
                                <template v-if="otpStep">
                                    <a-alert
                                        :message="'OTP sent to ' + otpEmailHint"
                                        type="info"
                                        show-icon
                                        class="mb-20 mt-10"
                                    />
                                    <a-form-item
                                        label="Enter OTP"
                                        name="otp"
                                        :help="rules.otp ? rules.otp.message : null"
                                        :validateStatus="rules.otp ? 'error' : null"
                                    >
                                        <a-input
                                            v-model:value="otpCode"
                                            @pressEnter="onVerifyOtp"
                                            placeholder="Enter 6-digit OTP"
                                            :maxlength="6"
                                            style="text-align: center; font-size: 18px; letter-spacing: 8px;"
                                        />
                                    </a-form-item>

                                    <a-form-item class="mt-30">
                                        <a-button
                                            :loading="loading"
                                            @click="onVerifyOtp"
                                            class="login-btn"
                                            block
                                        >
                                            Verify OTP
                                        </a-button>
                                    </a-form-item>
                                    <div style="text-align: center; margin-top: 10px;">
                                        <a-button type="link" @click="backToLogin">Back to Login</a-button>
                                    </div>
                                </template>

                                <!-- Normal Login Step -->
                                <template v-else>
                                    <a-form-item
                                        :label="$t('user.email_phone')"
                                        name="email"
                                        :help="rules.email ? rules.email.message : null"
                                        :validateStatus="rules.email ? 'error' : null"
                                    >
                                        <a-input
                                            v-model:value="credentials.email"
                                            @pressEnter="onSubmit"
                                            :placeholder="
                                                $t('common.placeholder_default_text', [
                                                    $t('user.email_phone'),
                                                ])
                                            "
                                        />
                                    </a-form-item>

                                    <a-form-item
                                        :label="$t('user.password')"
                                        name="password"
                                        :help="rules.password ? rules.password.message : null"
                                        :validateStatus="rules.password ? 'error' : null"
                                    >
                                        <a-input-password
                                            v-model:value="credentials.password"
                                            @pressEnter="onSubmit"
                                            :placeholder="
                                                $t('common.placeholder_default_text', [
                                                    $t('user.password'),
                                                ])
                                            "
                                        />
                                    </a-form-item>

                                    <a-form-item class="mt-30">
                                        <a-button
                                            :loading="loading"
                                            @click="onSubmit"
                                            class="login-btn"
                                            block
                                        >
                                            {{ $t("menu.login") }}
                                        </a-button>
                                    </a-form-item>
                                </template>
                            </a-form>
                        </a-card>
                    </a-col>
                </a-row>
            </a-col>
            <a-col :xs="0" :sm="0" :md="0" :lg="16">
                <div class="right-login-div">
                    <img class="right-image" :src="loginBackground" />
                </div>
            </a-col>
        </a-row>
    </div>
</template>

<script>
import { defineComponent, reactive, ref } from "vue";
import { useStore } from "vuex";
import { useRouter } from "vue-router";
import common from "../../../common/composable/common";
import apiAdmin from "../../../common/composable/apiAdmin";

export default defineComponent({
    components: {},
    setup() {
        const { addEditRequestAdmin, loading, rules } = apiAdmin();
        const { globalSetting, appType } = common();
        const loginBackground = globalSetting.value?.login_image_url || window.config.login_background;
        const store = useStore();
        const router = useRouter();
        const credentials = reactive({
            email: null,
            password: null,
        });
        const onRequestSend = ref({
            error: "",
            success: "",
        });

        // OTP state
        const otpStep = ref(false);
        const otpCode = ref("");
        const otpUserUid = ref("");
        const otpEmailHint = ref("");

        const handleLoginSuccess = async (response) => {
            const user = response.user;
            store.commit("auth/updateUser", user);
            store.commit("auth/updateToken", response.token);
            store.commit("auth/updateExpires", response.expires_in);
            store.commit(
                "auth/updateVisibleSubscriptionModules",
                response.visible_subscription_modules
            );

            if (appType == "non-saas") {
                await store.dispatch("auth/updateAllWarehouses");
                store.commit("auth/updateWarehouse", response.user.warehouse);
                store.commit("auth/updateAppChecking", false);

                router.push({
                    name: "admin.dashboard.index",
                    params: { success: true },
                });
            } else {
                if (user.is_superadmin && user.user_type == "super_admins") {
                    store.commit("auth/updateApp", response.app);
                    store.commit(
                        "auth/updateEmailVerifiedSetting",
                        response.email_setting_verified
                    );
                    store.commit("auth/updateAppChecking", false);
                    router.push({
                        name: "superadmin.dashboard",
                        params: { success: true },
                    });
                } else {
                    store.commit("auth/updateApp", response.app);
                    store.commit(
                        "auth/updateEmailVerifiedSetting",
                        response.email_setting_verified
                    );
                    store.commit(
                        "auth/updateAddMenus",
                        response.shortcut_menus.credentials
                    );
                    await store.dispatch("auth/updateAllWarehouses");
                    store.commit("auth/updateWarehouse", response.user.warehouse);
                    store.commit("auth/updateAppChecking", false);
                    router.push({
                        name: "admin.dashboard.index",
                        params: { success: true },
                    });
                }
            }
        };

        const onSubmit = () => {
            onRequestSend.value = {
                error: "",
                success: false,
            };

            addEditRequestAdmin({
                url: "auth/login",
                data: credentials,
                success: async (response) => {
                    // Check if OTP is required
                    if (response.requires_otp) {
                        otpStep.value = true;
                        otpUserUid.value = response.user_uid;
                        otpEmailHint.value = response.email_hint;
                        otpCode.value = "";
                        return;
                    }

                    await handleLoginSuccess(response);
                },
                error: (err) => {
                    onRequestSend.value = {
                        error: err.error.message ? err.error.message : "",
                        success: false,
                    };
                },
            });
        };

        const onVerifyOtp = () => {
            onRequestSend.value = {
                error: "",
                success: false,
            };

            addEditRequestAdmin({
                url: "auth/verify-otp",
                data: {
                    user_uid: otpUserUid.value,
                    otp: otpCode.value,
                    email: credentials.email,
                    password: credentials.password,
                },
                success: async (response) => {
                    await handleLoginSuccess(response);
                },
                error: (err) => {
                    onRequestSend.value = {
                        error: err.error.message ? err.error.message : "",
                        success: false,
                    };
                },
            });
        };

        const backToLogin = () => {
            otpStep.value = false;
            otpCode.value = "";
            otpUserUid.value = "";
            otpEmailHint.value = "";
            onRequestSend.value = { error: "", success: false };
        };

        return {
            loading,
            rules,
            credentials,
            onSubmit,
            onRequestSend,
            globalSetting,
            loginBackground,
            otpStep,
            otpCode,
            otpEmailHint,
            onVerifyOtp,
            backToLogin,

            innerWidth: window.innerWidth,
        };
    },
});
</script>

<style lang="less">
.login-main-container {
    background: #fff;
    height: 100vh;
}

.main-container-div {
    height: 100%;
}

.login-left-div {
    height: 100%;
    align-items: center;
}

.login-logo {
    text-align: center;
}

.login-img-logo {
    width: 150px;
}

.container-content {
    margin-top: 100px;
}

.login-div {
    border-radius: 10px;
}

.outer-div {
    margin: 0;
}

.right-login-div {
    background: #f8f8ff;
    height: 100%;
    display: flex;
    align-items: center;
}

.right-image {
    width: 100%;
    display: block;
    margin: 0 auto;
    height: calc(100vh);
}

.login-btn,
.login-btn:hover,
.login-btn:active {
    background: #5254cf !important;
    border-color: #5254cf !important;
    border-radius: 5px;
    color: #fff !important;
}
</style>

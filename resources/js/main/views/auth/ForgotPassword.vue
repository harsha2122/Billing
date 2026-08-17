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
                                    :message="onRequestSend.success"
                                    type="success"
                                    show-icon
                                    class="mb-20 mt-10"
                                />

                                <!-- Step 1: Request OTP -->
                                <template v-if="step === 1">
                                    <p>Enter your registered email address. We'll send you an OTP to reset your password.</p>
                                    <a-form-item
                                        label="Email"
                                        name="email"
                                        :help="rules.email ? rules.email.message : null"
                                        :validateStatus="rules.email ? 'error' : null"
                                    >
                                        <a-input
                                            v-model:value="formData.email"
                                            @pressEnter="onSendOtp"
                                            placeholder="Enter your registered email"
                                        />
                                    </a-form-item>

                                    <a-form-item class="mt-30">
                                        <a-button
                                            :loading="loading"
                                            @click="onSendOtp"
                                            class="login-btn"
                                            block
                                        >
                                            Send OTP
                                        </a-button>
                                    </a-form-item>
                                </template>

                                <!-- Step 2: Enter OTP + New Password -->
                                <template v-else>
                                    <p>Enter the OTP sent to {{ formData.email }} and choose a new password.</p>
                                    <a-form-item
                                        label="OTP"
                                        name="otp"
                                        :help="rules.otp ? rules.otp.message : null"
                                        :validateStatus="rules.otp ? 'error' : null"
                                    >
                                        <a-input
                                            v-model:value="formData.otp"
                                            placeholder="Enter 6-digit OTP"
                                            :maxlength="6"
                                            style="text-align: center; font-size: 18px; letter-spacing: 8px;"
                                        />
                                    </a-form-item>

                                    <a-form-item
                                        label="New Password"
                                        name="password"
                                        :help="rules.password ? rules.password.message : null"
                                        :validateStatus="rules.password ? 'error' : null"
                                    >
                                        <a-input-password
                                            v-model:value="formData.password"
                                            placeholder="Enter new password"
                                        />
                                    </a-form-item>

                                    <a-form-item
                                        label="Confirm Password"
                                        name="password_confirmation"
                                    >
                                        <a-input-password
                                            v-model:value="formData.password_confirmation"
                                            @pressEnter="onResetPassword"
                                            placeholder="Confirm new password"
                                        />
                                    </a-form-item>

                                    <a-form-item class="mt-30">
                                        <a-button
                                            :loading="loading"
                                            @click="onResetPassword"
                                            class="login-btn"
                                            block
                                        >
                                            Reset Password
                                        </a-button>
                                    </a-form-item>

                                    <div style="text-align: center; margin-top: 10px;">
                                        <a-button type="link" @click="step = 1">Resend OTP</a-button>
                                    </div>
                                </template>

                                <div style="text-align: center; margin-top: 10px;">
                                    <router-link :to="{ name: 'admin.login' }">Back to Login</router-link>
                                </div>
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
import { useRouter } from "vue-router";
import common from "../../../common/composable/common";
import apiAdmin from "../../../common/composable/apiAdmin";

export default defineComponent({
    setup() {
        const { addEditRequestAdmin, loading, rules } = apiAdmin();
        const { globalSetting } = common();
        const loginBackground = globalSetting.value?.login_image_url || window.config.login_background;
        const router = useRouter();

        const step = ref(1);
        const formData = reactive({
            email: null,
            otp: null,
            password: null,
            password_confirmation: null,
        });
        const onRequestSend = ref({
            error: "",
            success: "",
        });

        const onSendOtp = () => {
            onRequestSend.value = { error: "", success: "" };

            addEditRequestAdmin({
                url: "auth/forgot-password",
                data: { email: formData.email },
                success: (response) => {
                    onRequestSend.value = { error: "", success: response.message || "OTP sent to your email" };
                    step.value = 2;
                },
                error: (err) => {
                    onRequestSend.value = { error: err.error?.message || "", success: "" };
                },
            });
        };

        const onResetPassword = () => {
            onRequestSend.value = { error: "", success: "" };

            addEditRequestAdmin({
                url: "auth/reset-password",
                data: {
                    email: formData.email,
                    otp: formData.otp,
                    password: formData.password,
                    password_confirmation: formData.password_confirmation,
                },
                success: () => {
                    onRequestSend.value = { error: "", success: "Password reset successfully. Redirecting to login..." };
                    setTimeout(() => {
                        router.push({ name: "admin.login" });
                    }, 1500);
                },
                error: (err) => {
                    onRequestSend.value = { error: err.error?.message || "", success: "" };
                },
            });
        };

        return {
            loading,
            rules,
            step,
            formData,
            onRequestSend,
            globalSetting,
            loginBackground,
            onSendOtp,
            onResetPassword,
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
</style>

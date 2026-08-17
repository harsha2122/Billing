<template>
	<AdminPageHeader>
		<template #header>
			<a-page-header :title="$t(`menu.app_settings`)" class="p-0">
				<template v-if="user && user.is_superadmin" #extra>
					<a-button type="primary" @click="onSubmit">
						<template #icon> <SaveOutlined /> </template>
						{{ $t("common.update") }}
					</a-button>
				</template>
			</a-page-header>
		</template>
		<template #breadcrumb>
			<a-breadcrumb separator="-" style="font-size: 12px">
				<a-breadcrumb-item>
					<router-link :to="{ name: 'admin.dashboard.index' }">
						{{ $t(`menu.dashboard`) }}
					</router-link>
				</a-breadcrumb-item>
				<a-breadcrumb-item>
					{{ $t("menu.settings") }}
				</a-breadcrumb-item>
				<a-breadcrumb-item>
					{{ $t("menu.app_settings") }}
				</a-breadcrumb-item>
			</a-breadcrumb>
		</template>
	</AdminPageHeader>

	<a-row>
		<a-col :xs="24" :sm="24" :md="24" :lg="4" :xl="4" class="bg-setting-sidebar">
			<SettingSidebar />
		</a-col>
		<a-col :xs="24" :sm="24" :md="24" :lg="20" :xl="20">
			<a-card class="page-content-container">
				<a-alert
					v-if="!user || !user.is_superadmin"
					message="Unauthorized Access"
					description="Only SuperAdmin can access global application settings."
					type="error"
					show-icon
				/>
				<a-form v-else layout="vertical">
					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('app_settings.site_name')"
								name="site_name"
								:help="rules.site_name ? rules.site_name.message : null"
								:validateStatus="rules.site_name ? 'error' : null"
							>
								<a-input
									v-model:value="formData.site_name"
									placeholder="Enter site name"
								/>
							</a-form-item>
						</a-col>
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('app_settings.primary_color')"
								name="primary_color"
								:help="rules.primary_color ? rules.primary_color.message : null"
								:validateStatus="rules.primary_color ? 'error' : null"
							>
								<a-input
									v-model:value="formData.primary_color"
									type="color"
									placeholder="#1890ff"
								/>
							</a-form-item>
						</a-col>
					</a-row>

					<a-divider>{{ $t("app_settings.logos") }}</a-divider>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('app_settings.light_logo')"
								name="light_logo"
								:help="rules.light_logo ? rules.light_logo.message : null"
								:validateStatus="rules.light_logo ? 'error' : null"
							>
								<Upload
									:formData="formData"
									folder="app-settings"
									imageField="light_logo"
									@onFileUploaded="
										(file) => {
											formData.light_logo = file.file;
										}
									"
								/>
							</a-form-item>
						</a-col>
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('app_settings.dark_logo')"
								name="dark_logo"
								:help="rules.dark_logo ? rules.dark_logo.message : null"
								:validateStatus="rules.dark_logo ? 'error' : null"
							>
								<Upload
									:formData="formData"
									folder="app-settings"
									imageField="dark_logo"
									@onFileUploaded="
										(file) => {
											formData.dark_logo = file.file;
										}
									"
								/>
							</a-form-item>
						</a-col>
					</a-row>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('app_settings.small_light_logo')"
								name="small_light_logo"
								:help="rules.small_light_logo ? rules.small_light_logo.message : null"
								:validateStatus="rules.small_light_logo ? 'error' : null"
							>
								<Upload
									:formData="formData"
									folder="app-settings"
									imageField="small_light_logo"
									@onFileUploaded="
										(file) => {
											formData.small_light_logo = file.file;
										}
									"
								/>
							</a-form-item>
						</a-col>
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('app_settings.small_dark_logo')"
								name="small_dark_logo"
								:help="rules.small_dark_logo ? rules.small_dark_logo.message : null"
								:validateStatus="rules.small_dark_logo ? 'error' : null"
							>
								<Upload
									:formData="formData"
									folder="app-settings"
									imageField="small_dark_logo"
									@onFileUploaded="
										(file) => {
											formData.small_dark_logo = file.file;
										}
									"
								/>
							</a-form-item>
						</a-col>
					</a-row>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('app_settings.loader_logo')"
								name="loader_logo"
								:help="rules.loader_logo ? rules.loader_logo.message : null"
								:validateStatus="rules.loader_logo ? 'error' : null"
							>
								<Upload
									:formData="formData"
									folder="app-settings"
									imageField="loader_logo"
									@onFileUploaded="
										(file) => {
											formData.loader_logo = file.file;
										}
									"
								/>
							</a-form-item>
						</a-col>
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('app_settings.favicon')"
								name="favicon"
								:help="rules.favicon ? rules.favicon.message : null"
								:validateStatus="rules.favicon ? 'error' : null"
							>
								<Upload
									:formData="formData"
									folder="app-settings"
									imageField="favicon"
									@onFileUploaded="
										(file) => {
											formData.favicon = file.file;
										}
									"
								/>
							</a-form-item>
						</a-col>
					</a-row>

					<a-divider>{{ $t("app_settings.seo_settings") }}</a-divider>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="24" :lg="24">
							<a-form-item
								:label="$t('app_settings.meta_description')"
								name="meta_description"
							>
								<a-textarea
									v-model:value="formData.meta_description"
									:rows="3"
									placeholder="Enter meta description"
								/>
							</a-form-item>
						</a-col>
					</a-row>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="24" :lg="24">
							<a-form-item
								:label="$t('app_settings.meta_keywords')"
								name="meta_keywords"
							>
								<a-textarea
									v-model:value="formData.meta_keywords"
									:rows="3"
									placeholder="Enter meta keywords (comma separated)"
								/>
							</a-form-item>
						</a-col>
					</a-row>

					<a-divider>SMTP Settings (used for OTP & password reset emails)</a-divider>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="24" :lg="24">
							<a-form-item name="smtp_enabled">
								<a-switch v-model:checked="formData.smtp_enabled" />
								<span style="margin-left: 10px">Enable SMTP</span>
							</a-form-item>
						</a-col>
					</a-row>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('mail_settings.host')"
								name="smtp_host"
								:help="rules.smtp_host ? rules.smtp_host.message : null"
								:validateStatus="rules.smtp_host ? 'error' : null"
							>
								<a-input v-model:value="formData.smtp_host" placeholder="smtp.gmail.com" />
							</a-form-item>
						</a-col>
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item :label="$t('mail_settings.port')" name="smtp_port">
								<a-input v-model:value="formData.smtp_port" placeholder="587" />
							</a-form-item>
						</a-col>
					</a-row>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item :label="$t('mail_settings.username')" name="smtp_username">
								<a-input v-model:value="formData.smtp_username" placeholder="you@gmail.com" />
							</a-form-item>
						</a-col>
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item
								:label="$t('mail_settings.password')"
								name="smtp_password"
								help="Leave blank to keep current password. Use a Gmail App Password, not your login password."
							>
								<a-input-password v-model:value="formData.smtp_password" placeholder="Gmail App Password" />
							</a-form-item>
						</a-col>
					</a-row>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item :label="$t('mail_settings.encryption')" name="smtp_encryption">
								<a-select v-model:value="formData.smtp_encryption">
									<a-select-option value="tls">TLS</a-select-option>
									<a-select-option value="ssl">SSL</a-select-option>
								</a-select>
							</a-form-item>
						</a-col>
					</a-row>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item :label="$t('mail_settings.from_name')" name="smtp_from_name">
								<a-input v-model:value="formData.smtp_from_name" />
							</a-form-item>
						</a-col>
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item :label="$t('mail_settings.from_email')" name="smtp_from_email">
								<a-input v-model:value="formData.smtp_from_email" />
							</a-form-item>
						</a-col>
					</a-row>

					<a-row :gutter="16">
						<a-col :xs="24" :sm="24" :md="12" :lg="12">
							<a-form-item label="Send Test Mail To">
								<a-input-group compact>
									<a-input
										v-model:value="testMailEmail"
										style="width: calc(100% - 120px)"
										placeholder="Enter email to test"
									/>
									<a-button :loading="testMailLoading" @click="onSendTestMail" style="width: 120px">
										{{ $t("mail_settings.send_test_mail") }}
									</a-button>
								</a-input-group>
							</a-form-item>
						</a-col>
					</a-row>

				</a-form>
			</a-card>
		</a-col>
	</a-row>
</template>

<script>
import { defineComponent, ref, onMounted, computed } from "vue";
import { SaveOutlined } from "@ant-design/icons-vue";
import { useI18n } from "vue-i18n";
import { useStore } from "vuex";
import { notification } from "ant-design-vue";
import AdminPageHeader from "../../../../common/layouts/AdminPageHeader.vue";
import SettingSidebar from "../SettingSidebar.vue";
import Upload from "../../../../common/core/ui/file/Upload.vue";
import common from "../../../../common/composable/common";
import apiAdmin from "../../../../common/composable/apiAdmin";

export default defineComponent({
	components: {
		SaveOutlined,
		AdminPageHeader,
		SettingSidebar,
		Upload,
	},
	setup() {
		const { t } = useI18n();
		const store = useStore();
		const { permsArray, appSetting } = common();
		const { addEditRequestAdmin, loading, rules } = apiAdmin();
		const user = computed(() => store.state.auth.user);
		const axiosAdmin = appSetting.axiosAdmin;

		const formData = ref({
			site_name: "",
			primary_color: "#1890ff",
			light_logo: "",
			dark_logo: "",
			small_light_logo: "",
			small_dark_logo: "",
			loader_logo: "",
			favicon: "",
			meta_description: "",
			meta_keywords: "",
			smtp_enabled: false,
			smtp_host: "",
			smtp_port: "",
			smtp_username: "",
			smtp_password: "",
			smtp_encryption: "tls",
			smtp_from_name: "",
			smtp_from_email: "",
		});

		const testMailEmail = ref("");
		const testMailLoading = ref(false);

		onMounted(() => {
			fetchSettings();
		});

		const fetchSettings = () => {
			axiosAdmin.get("app-settings").then((response) => {
				const settings = response.data.app_settings;
				if (settings) {
					formData.value = {
						site_name: settings.site_name || "",
						primary_color: settings.primary_color || "#1890ff",
						light_logo: settings.light_logo || "",
						dark_logo: settings.dark_logo || "",
						small_light_logo: settings.small_light_logo || "",
						small_dark_logo: settings.small_dark_logo || "",
						loader_logo: settings.loader_logo || "",
						favicon: settings.favicon || "",
						meta_description: settings.meta_description || "",
						meta_keywords: settings.meta_keywords || "",
						smtp_enabled: settings.smtp_enabled ? true : false,
						smtp_host: settings.smtp_host || "",
						smtp_port: settings.smtp_port || "",
						smtp_username: settings.smtp_username || "",
						smtp_password: "",
						smtp_encryption: settings.smtp_encryption || "tls",
						smtp_from_name: settings.smtp_from_name || "",
						smtp_from_email: settings.smtp_from_email || "",
					};
				}
			}).catch((error) => {
				console.error("Failed to fetch app settings:", error);
			});
		};

		const onSubmit = () => {
			axiosAdmin.post("app-settings", formData.value).then((response) => {
				notification.success({
					message: "Settings updated successfully",
				});
				if (response.data.app_settings) {
					// Update global settings in store if available
					store.dispatch("auth/updateAppSettings", response.data.app_settings).catch(() => {});
				}
				fetchSettings();
			}).catch((error) => {
				notification.error({
					message: "Failed to update settings",
					description: error.response?.data?.message || error.message,
				});
			});
		};

		const onSendTestMail = () => {
			if (!testMailEmail.value) {
				notification.error({ message: "Please enter an email to send the test mail to" });
				return;
			}

			testMailLoading.value = true;
			axiosAdmin.post("app-settings/send-test-mail", { email: testMailEmail.value }).then(() => {
				notification.success({ message: "Test mail sent successfully" });
				testMailLoading.value = false;
			}).catch((error) => {
				notification.error({
					message: "Failed to send test mail",
					description: error.response?.data?.message || error.message,
				});
				testMailLoading.value = false;
			});
		};

		return {
			formData,
			rules,
			loading,
			permsArray,
			user,
			onSubmit,
			testMailEmail,
			testMailLoading,
			onSendTestMail,
		};
	},
});
</script>

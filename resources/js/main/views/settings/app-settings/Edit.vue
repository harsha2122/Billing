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
		});

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

		return {
			formData,
			rules,
			loading,
			permsArray,
			user,
			onSubmit,
		};
	},
});
</script>

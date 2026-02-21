import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { useStore } from "vuex";
import { find } from "lodash-es";

const fields = () => {
    const { t } = useI18n();
    const store = useStore();
    const taxes = ref([]);
    const warehouses = ref([]);
    const customers = ref([]);
    const brands = ref([]);
    const categories = ref([]);
    const productLists = ref([]);
    const posDefaultCustomer = ref({});

    const formData = ref({
        user_id: undefined,
        tax_id: undefined,
        category_id: undefined,
        brand_id: undefined,
        tax_rate: 0,
        tax_amount: 0,
        discount: 0,
        discount_type: "flat",
        discount_percent: 0,
        manual_gst_rate: null,
        shipping: 0,
        subtotal: 0,
        e_way_bill_number: "",
        irn_number: "",
        qr_code_data: "",
        pos_invoice_template_id: undefined,
    });

    const orderItemColumns = [
        {
            title: "#",
            dataIndex: "sn",
        },
        {
            title: t("product.name"),
            dataIndex: "name",
        },
        {
            title: t("product.quantity"),
            dataIndex: "unit_quantity",
        },
        {
            title: t("product.subtotal"),
            dataIndex: "subtotal",
        },
        {
            title: t("common.action"),
            dataIndex: "action",
        },
    ];

    const customerUrl = "customers?limit=10000";

    const getPreFetchData = () => {
        const taxesPromise = axiosAdmin.get("taxes?limit=10000");
        const customersPromise = axiosAdmin.get(customerUrl);
        const categoriesPromise = axiosAdmin.get("categories?limit=10000");
        const brandsPromise = axiosAdmin.get("brands?limit=10000");
        const productsPromise = axiosAdmin.post("pos/products", {
            brand_id: formData.value.brand_id,
            category_id: formData.value.category_id,
        });
        const defaultWalkinCustomerPromise = axiosAdmin.get("default-walkin-customer");

        Promise.all([
            taxesPromise,
            customersPromise,
            productsPromise,
            categoriesPromise,
            brandsPromise,
            defaultWalkinCustomerPromise,
        ]).then(
            ([
                taxesResponse,
                customersResponse,
                productResponse,
                caegoriesResponse,
                brandsResponse,
                defaultWalkinCustomerResponse
            ]) => {
                taxes.value = taxesResponse.data;
                customers.value = customersResponse.data;
                categories.value = caegoriesResponse.data;
                brands.value = brandsResponse.data;
                productLists.value = productResponse.data.products;

                if (defaultWalkinCustomerResponse.data && defaultWalkinCustomerResponse.data.customer) {
                    var walkinXid = defaultWalkinCustomerResponse.data.customer.xid;
                    var defaultWalkInCustomer = find(customers.value, ["xid", walkinXid]);
                    if (defaultWalkInCustomer) {
                        posDefaultCustomer.value = defaultWalkInCustomer;
                        formData.value = { ...formData.value, user_id: defaultWalkInCustomer.xid };
                    } else if (customers.value.length > 0) {
                        // Fallback: find walk-in customer by name
                        var walkinByName = find(customers.value, ["is_walkin_customer", 1]);
                        if (walkinByName) {
                            posDefaultCustomer.value = walkinByName;
                            formData.value = { ...formData.value, user_id: walkinByName.xid };
                        }
                    }
                }
            }
        );
    };

    return {
        taxes,
        customers,
        brands,
        categories,
        productLists,
        formData,

        customerUrl,

        orderItemColumns,
        getPreFetchData,
        posDefaultCustomer,
    }
}

export default fields;

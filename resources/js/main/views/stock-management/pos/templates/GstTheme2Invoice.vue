<template>
    <div class="gst-theme2-invoice">
        <!-- Top Title -->
        <div class="top-title-bar">
            <h3>Tax Invoice</h3>
        </div>

        <!-- Header Section -->
        <div class="header-section">
            <div class="header-logo" v-if="(selectedWarehouse && selectedWarehouse.logo_url) || (appSetting && appSetting.light_logo_url)">
                <img
                    :src="selectedWarehouse && selectedWarehouse.logo_url ? selectedWarehouse.logo_url : appSetting.light_logo_url"
                    :alt="selectedWarehouse ? selectedWarehouse.name : appSetting.name"
                    class="company-logo"
                />
            </div>
            <div class="header-company-info">
                <h2 class="company-name">
                    {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}
                </h2>
                <p>{{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}</p>
                <p v-if="(selectedWarehouse && selectedWarehouse.phone) || (appSetting && appSetting.phone)">
                    Phone: {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}
                </p>
                <p v-if="(selectedWarehouse && selectedWarehouse.email) || (appSetting && appSetting.email)">
                    Email: {{ selectedWarehouse ? selectedWarehouse.email : appSetting.email }}
                </p>
                <p v-if="selectedWarehouse && selectedWarehouse.gstin">
                    GSTIN: {{ selectedWarehouse.gstin }}
                </p>
            </div>
        </div>

        <!-- Invoice Meta -->
        <div class="invoice-meta">
            <table class="meta-table">
                <tr>
                    <td><strong>Invoice No:</strong> {{ order.invoice_number }}</td>
                    <td class="text-right"><strong>Date:</strong> {{ formatDate(order.order_date) }}</td>
                </tr>
            </table>
        </div>

        <!-- Bill To Bar -->
        <div class="bill-to-bar">
            <span>Bill To</span>
        </div>

        <!-- Customer Details -->
        <div class="customer-details">
            <table class="customer-table">
                <tr>
                    <td>
                        <strong>{{ order.user ? order.user.name : '' }}</strong>
                    </td>
                    <td class="text-right">
                        <span v-if="order.staff_member">Sold By: {{ order.staff_member.name }}</span>
                    </td>
                </tr>
                <tr v-if="order.user && (order.user.phone || order.user.tax_number)">
                    <td>
                        <span v-if="order.user.phone">Phone: {{ order.user.phone }}</span>
                    </td>
                    <td class="text-right">
                        <span v-if="order.user.tax_number">GSTIN: {{ order.user.tax_number }}</span>
                    </td>
                </tr>
            </table>
        </div>

        <!-- Items Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th class="col-sn">#</th>
                    <th class="col-item">Item</th>
                    <th class="col-hsn">HSN/SAC</th>
                    <th class="col-qty">Qty</th>
                    <th class="col-rate">Rate</th>
                    <th class="col-tax">Tax</th>
                    <th class="col-amount">Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(item, index) in order.items" :key="index">
                    <td>{{ index + 1 }}</td>
                    <td>{{ item.product ? item.product.name : '' }}</td>
                    <td>{{ item.hsn_sac_code || (item.product ? item.product.hsn_sac_code : '') }}</td>
                    <td>{{ item.quantity }}{{ item.unit ? item.unit.short_name : '' }}</td>
                    <td>{{ formatAmountCurrency(item.single_unit_price) }}</td>
                    <td>
                        <span v-if="item.total_tax">{{ formatAmountCurrency(item.total_tax) }}</span>
                        <span v-else>-</span>
                    </td>
                    <td class="text-right">{{ formatAmountCurrency(item.subtotal) }}</td>
                </tr>
            </tbody>
        </table>

        <!-- Amounts Section -->
        <div class="amounts-section">
            <table class="amounts-table">
                <tr>
                    <td>Subtotal</td>
                    <td class="text-right">{{ formatAmountCurrency(order.subtotal) }}</td>
                </tr>
                <tr v-if="order.tax_amount">
                    <td>Tax ({{ order.tax_rate }}%)</td>
                    <td class="text-right">{{ formatAmountCurrency(order.tax_amount) }}</td>
                </tr>
                <tr v-if="order.discount">
                    <td>Discount</td>
                    <td class="text-right">- {{ formatAmountCurrency(order.discount) }}</td>
                </tr>
                <tr v-if="order.shipping">
                    <td>Shipping</td>
                    <td class="text-right">{{ formatAmountCurrency(order.shipping) }}</td>
                </tr>
                <tr class="grand-total-row">
                    <td><strong>Total</strong></td>
                    <td class="text-right"><strong>{{ formatAmountCurrency(order.total) }}</strong></td>
                </tr>
                <tr>
                    <td>Paid Amount</td>
                    <td class="text-right">{{ formatAmountCurrency(order.paid_amount) }}</td>
                </tr>
                <tr v-if="order.due_amount">
                    <td>Due Amount</td>
                    <td class="text-right">{{ formatAmountCurrency(order.due_amount) }}</td>
                </tr>
            </table>
        </div>

        <!-- Amount in Words Bar -->
        <div class="amount-words-bar" v-if="amountInWords">
            <strong>Amount in Words:</strong> {{ amountInWords }}
        </div>

        <!-- Payment Mode -->
        <div class="payment-info" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment Mode:</strong>
            <span v-for="(payment, pIndex) in order.order_payments" :key="'pay-' + pIndex">
                {{ formatAmountCurrency(payment.amount) }}
                <span v-if="payment.payment && payment.payment.payment_mode">
                    ({{ payment.payment.payment_mode.name }})
                </span>
                <span v-if="pIndex < order.order_payments.length - 1">, </span>
            </span>
        </div>

        <!-- Terms & Conditions -->
        <div class="terms-section" v-if="order.terms_condition || (selectedWarehouse && selectedWarehouse.terms_condition)">
            <strong>Terms & Conditions:</strong>
            <p>{{ order.terms_condition || (selectedWarehouse ? selectedWarehouse.terms_condition : '') }}</p>
        </div>

        <!-- Authorized Signatory -->
        <div class="signatory-section">
            <div class="signatory-block">
                <p class="for-company">For {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</p>
                <img
                    v-if="selectedWarehouse && selectedWarehouse.signature_url"
                    :src="selectedWarehouse.signature_url"
                    alt="Signature"
                    class="signature-img"
                />
                <div class="signatory-line"></div>
                <p>Authorized Signatory</p>
            </div>
        </div>
    </div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
    name: "GstTheme2Invoice",
    props: [
        "order",
        "appSetting",
        "selectedWarehouse",
        "formatAmountCurrency",
        "formatDate",
        "amountInWords",
    ],
});
</script>

<style scoped>
.gst-theme2-invoice {
    max-width: 400px;
    margin: 0 auto;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11px;
    color: #333;
    line-height: 1.4;
}

.top-title-bar {
    background: #6c3483;
    color: #fff;
    text-align: center;
    padding: 6px 0;
    margin-bottom: 8px;
}

.top-title-bar h3 {
    margin: 0;
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.header-section {
    display: flex;
    align-items: flex-start;
    justify-content: flex-end;
    margin-bottom: 6px;
    padding: 0 4px;
}

.header-logo {
    margin-right: 10px;
}

.company-logo {
    max-width: 60px;
    max-height: 45px;
    object-fit: contain;
}

.header-company-info {
    text-align: right;
    flex: 1;
}

.company-name {
    margin: 0 0 2px 0;
    font-size: 14px;
    color: #6c3483;
}

.header-company-info p {
    margin: 0;
    font-size: 10px;
}

.invoice-meta {
    margin-bottom: 4px;
}

.meta-table {
    width: 100%;
    border-collapse: collapse;
}

.meta-table td {
    padding: 2px 4px;
    font-size: 11px;
}

.text-right {
    text-align: right;
}

.bill-to-bar {
    background: #6c3483;
    color: #fff;
    padding: 3px 8px;
    font-size: 11px;
    font-weight: bold;
    margin-bottom: 4px;
}

.customer-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 6px;
}

.customer-table td {
    padding: 2px 4px;
    font-size: 10px;
}

.items-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 6px;
}

.items-table thead tr {
    background: #6c3483;
    color: #fff;
}

.items-table th {
    padding: 4px 3px;
    font-size: 9px;
    text-align: left;
    border: 1px solid #6c3483;
}

.items-table td {
    padding: 3px;
    font-size: 10px;
    border-bottom: 1px solid #eee;
}

.col-sn { width: 5%; }
.col-item { width: 25%; }
.col-hsn { width: 13%; }
.col-qty { width: 10%; }
.col-rate { width: 16%; }
.col-tax { width: 14%; }
.col-amount { width: 17%; text-align: right; }

.amounts-section {
    margin-bottom: 6px;
    padding: 0 4px;
}

.amounts-table {
    width: 60%;
    margin-left: auto;
    border-collapse: collapse;
}

.amounts-table td {
    padding: 2px 4px;
    font-size: 11px;
    border-bottom: 1px dotted #ddd;
}

.grand-total-row td {
    border-top: 2px solid #6c3483;
    border-bottom: 2px solid #6c3483;
    padding: 4px;
    font-size: 12px;
    color: #6c3483;
}

.amount-words-bar {
    background: #6c3483;
    color: #fff;
    padding: 4px 8px;
    font-size: 10px;
    margin-bottom: 6px;
}

.payment-info {
    font-size: 10px;
    padding: 3px 4px;
    margin-bottom: 4px;
    border-bottom: 1px dashed #ddd;
}

.terms-section {
    margin-bottom: 8px;
    font-size: 9px;
    padding: 0 4px;
}

.terms-section p {
    margin: 2px 0 0 0;
}

.signatory-section {
    text-align: right;
    margin-top: 12px;
    padding: 0 4px;
}

.signatory-block {
    display: inline-block;
    text-align: center;
}

.signatory-block p {
    margin: 2px 0;
    font-size: 10px;
}

.for-company {
    font-weight: bold;
    color: #6c3483;
}

.signature-img {
    max-width: 100px;
    max-height: 40px;
    object-fit: contain;
    display: block;
    margin: 4px auto;
}

.signatory-line {
    width: 120px;
    border-top: 1px solid #333;
    margin: 4px auto;
}
</style>

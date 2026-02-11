<template>
    <div class="landscape-theme1-invoice">
        <div class="header-section">
            <div class="header-left">
                <img v-if="selectedWarehouse && selectedWarehouse.logo_url" :src="selectedWarehouse.logo_url" :alt="selectedWarehouse.name" class="company-logo" />
                <img v-else-if="appSetting && appSetting.light_logo_url" :src="appSetting.light_logo_url" :alt="appSetting.name" class="company-logo" />
            </div>
            <div class="header-center">
                <h2 class="company-name">{{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</h2>
                <p>{{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}</p>
                <p v-if="(selectedWarehouse && selectedWarehouse.phone) || (appSetting && appSetting.phone)">Phone: {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}</p>
                <p v-if="selectedWarehouse && selectedWarehouse.gstin">GSTIN: {{ selectedWarehouse.gstin }}</p>
            </div>
        </div>
        <div class="title-meta-row">
            <div class="invoice-title-chip">Tax Invoice</div>
            <div class="meta-info">
                <span><strong>No:</strong> {{ order.invoice_number }}</span>
                <span><strong>Date:</strong> {{ formatDate(order.order_date) }}</span>
            </div>
        </div>
        <table class="customer-table">
            <tr>
                <td><strong>Customer:</strong> {{ order.user ? order.user.name : '' }}</td>
                <td class="text-right"><span v-if="order.staff_member"><strong>Staff:</strong> {{ order.staff_member.name }}</span></td>
            </tr>
            <tr v-if="order.user && (order.user.phone || order.user.tax_number)">
                <td><span v-if="order.user.phone">Phone: {{ order.user.phone }}</span></td>
                <td class="text-right"><span v-if="order.user.tax_number">GSTIN: {{ order.user.tax_number }}</span></td>
            </tr>
        </table>
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width:5%">#</th>
                    <th style="width:26%">Item</th>
                    <th style="width:13%">HSN/SAC</th>
                    <th style="width:10%">Qty</th>
                    <th style="width:16%">Rate</th>
                    <th style="width:14%">Tax</th>
                    <th style="width:16%; text-align:right">Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(item, index) in order.items" :key="index">
                    <td>{{ index + 1 }}</td>
                    <td>{{ item.product ? item.product.name : '' }}</td>
                    <td>{{ item.hsn_sac_code || (item.product ? item.product.hsn_sac_code : '') }}</td>
                    <td>{{ item.quantity }}{{ item.unit ? item.unit.short_name : '' }}</td>
                    <td>{{ formatAmountCurrency(item.single_unit_price) }}</td>
                    <td><span v-if="item.total_tax">{{ formatAmountCurrency(item.total_tax) }}</span><span v-else>-</span></td>
                    <td class="text-right">{{ formatAmountCurrency(item.subtotal) }}</td>
                </tr>
            </tbody>
        </table>
        <div class="subtotals-row">
            <table class="subtotals-table">
                <tr v-if="order.tax_amount"><td>Tax ({{ order.tax_rate }}%)</td><td class="text-right">{{ formatAmountCurrency(order.tax_amount) }}</td></tr>
                <tr v-if="order.discount"><td>Discount</td><td class="text-right">- {{ formatAmountCurrency(order.discount) }}</td></tr>
                <tr v-if="order.shipping"><td>Shipping</td><td class="text-right">{{ formatAmountCurrency(order.shipping) }}</td></tr>
            </table>
        </div>
        <div class="total-words-row">
            <div class="total-value"><strong>Total: {{ formatAmountCurrency(order.total) }}</strong></div>
            <div class="words-value" v-if="amountInWords">{{ amountInWords }}</div>
        </div>
        <div class="received-balance-row">
            <div><strong>Received:</strong> {{ formatAmountCurrency(order.paid_amount) }}</div>
            <div v-if="order.due_amount"><strong>Balance:</strong> {{ formatAmountCurrency(order.due_amount) }}</div>
        </div>
        <div class="payment-info" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment:</strong>
            <span v-for="(payment, pIndex) in order.order_payments" :key="'pay-' + pIndex">
                {{ formatAmountCurrency(payment.amount) }}
                <span v-if="payment.payment && payment.payment.payment_mode">({{ payment.payment.payment_mode.name }})</span>
                <span v-if="pIndex < order.order_payments.length - 1">, </span>
            </span>
        </div>
        <div class="summary-bar"><span>Items: {{ order.total_items }}</span><span>Qty: {{ order.total_quantity }}</span></div>
        <div class="bottom-section">
            <div class="terms-column" v-if="order.terms_condition || (selectedWarehouse && selectedWarehouse.terms_condition)">
                <strong>Terms & Conditions:</strong>
                <p>{{ order.terms_condition || (selectedWarehouse ? selectedWarehouse.terms_condition : '') }}</p>
            </div>
            <div class="signatory-column">
                <p class="for-company">For {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</p>
                <img v-if="selectedWarehouse && selectedWarehouse.signature_url" :src="selectedWarehouse.signature_url" alt="Signature" class="signature-img" />
                <div class="signatory-line"></div>
                <p>Authorized Signatory</p>
            </div>
        </div>
    </div>
</template>

<script>
import { defineComponent } from "vue";
export default defineComponent({
    name: "LandscapeTheme1Invoice",
    props: ["order", "appSetting", "selectedWarehouse", "formatAmountCurrency", "formatDate", "amountInWords"],
});
</script>

<style scoped>
.landscape-theme1-invoice { width: 100%; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 11px; color: #1a1a1a; line-height: 1.5; }
.header-section { display: flex; align-items: flex-start; padding-bottom: 8px; border-bottom: 2px solid #2196F3; margin-bottom: 8px; }
.header-left { flex: 0 0 60px; margin-right: 10px; }
.company-logo { max-width: 55px; max-height: 40px; object-fit: contain; }
.header-center { flex: 1; }
.company-name { margin: 0 0 3px 0; font-size: 14px; color: #2196F3; font-weight: 700; }
.header-center p { margin: 0; font-size: 9px; color: #555; }
.title-meta-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
.invoice-title-chip { background: #2196F3; color: #fff; padding: 4px 14px; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; border-radius: 2px; }
.meta-info { font-size: 10px; }
.meta-info span { margin-left: 12px; }
.customer-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.customer-table td { padding: 3px 6px; font-size: 10px; border-bottom: 1px solid #f0f0f0; }
.text-right { text-align: right; }
.items-table { width: 100%; border-collapse: collapse; margin-bottom: 6px; }
.items-table thead tr { background: #2196F3; color: #fff; }
.items-table th { padding: 5px 6px; font-size: 9px; text-align: left; font-weight: 600; text-transform: uppercase; letter-spacing: 0.3px; }
.items-table td { padding: 4px 6px; font-size: 10px; border-bottom: 1px solid #f0f0f0; }
.items-table tbody tr:nth-child(even) { background: #fafafa; }
.subtotals-row { margin-bottom: 4px; }
.subtotals-table { width: 45%; margin-left: auto; border-collapse: collapse; }
.subtotals-table td { padding: 2px 6px; font-size: 10px; border-bottom: 1px solid #f0f0f0; }
.total-words-row { background: #2196F3; color: #fff; display: flex; align-items: center; justify-content: space-between; padding: 6px 10px; margin-bottom: 6px; }
.total-value { font-size: 13px; }
.words-value { font-size: 9px; font-style: italic; text-align: right; flex: 1; margin-left: 10px; opacity: 0.9; }
.received-balance-row { display: flex; justify-content: space-between; background: #e3f2fd; padding: 5px 10px; margin-bottom: 6px; font-size: 11px; border-radius: 2px; }
.payment-info { font-size: 10px; padding: 4px 6px; margin-bottom: 6px; border-bottom: 1px dashed #e0e0e0; }
.summary-bar { display: flex; justify-content: space-around; background: #f8f8f8; padding: 4px 0; margin-bottom: 8px; font-size: 10px; font-weight: 600; border-radius: 2px; }
.bottom-section { display: flex; align-items: flex-start; justify-content: space-between; margin-top: 10px; }
.terms-column { flex: 1; font-size: 9px; padding-right: 10px; color: #666; }
.terms-column p { margin: 2px 0 0 0; }
.signatory-column { flex: 0 0 auto; text-align: center; }
.signatory-column p { margin: 2px 0; font-size: 10px; }
.for-company { font-weight: 600; color: #2196F3; }
.signature-img { max-width: 90px; max-height: 35px; object-fit: contain; display: block; margin: 4px auto; }
.signatory-line { width: 100px; border-top: 1px solid #333; margin: 4px auto; }
</style>

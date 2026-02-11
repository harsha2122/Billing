<template>
    <div class="tally-theme-invoice">
        <div class="invoice-title"><h3>Tax Invoice</h3></div>
        <div class="company-box">
            <div class="company-box-inner">
                <div class="company-logo-section" v-if="(selectedWarehouse && selectedWarehouse.logo_url) || (appSetting && appSetting.light_logo_url)">
                    <img :src="selectedWarehouse && selectedWarehouse.logo_url ? selectedWarehouse.logo_url : appSetting.light_logo_url" :alt="selectedWarehouse ? selectedWarehouse.name : appSetting.name" class="company-logo" />
                </div>
                <div class="company-info-section">
                    <h2 class="company-name">{{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</h2>
                    <p>{{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}</p>
                    <p v-if="(selectedWarehouse && selectedWarehouse.phone) || (appSetting && appSetting.phone)">Phone: {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}</p>
                    <p v-if="(selectedWarehouse && selectedWarehouse.email) || (appSetting && appSetting.email)">Email: {{ selectedWarehouse ? selectedWarehouse.email : appSetting.email }}</p>
                    <p v-if="selectedWarehouse && selectedWarehouse.gstin">GSTIN: {{ selectedWarehouse.gstin }}</p>
                    <p v-if="selectedWarehouse && selectedWarehouse.state">State: {{ selectedWarehouse.state }} <span v-if="selectedWarehouse.state_code">({{ selectedWarehouse.state_code }})</span></p>
                </div>
            </div>
        </div>
        <div class="details-box">
            <table class="details-table">
                <tr><td><strong>Invoice No:</strong></td><td>{{ order.invoice_number }}</td><td><strong>Date:</strong></td><td>{{ formatDate(order.order_date) }}</td></tr>
                <tr><td><strong>Customer:</strong></td><td>{{ order.user ? order.user.name : '' }}</td><td><strong>Sold By:</strong></td><td>{{ order.staff_member ? order.staff_member.name : '' }}</td></tr>
                <tr v-if="order.user && (order.user.phone || order.user.tax_number)"><td><strong>Phone:</strong></td><td>{{ order.user ? order.user.phone : '' }}</td><td><strong>GSTIN:</strong></td><td>{{ order.user ? order.user.tax_number : '' }}</td></tr>
            </table>
        </div>
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width:5%">#</th>
                    <th style="width:26%">Description</th>
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
        <div class="totals-box">
            <table class="totals-table">
                <tr><td>Subtotal</td><td class="text-right">{{ formatAmountCurrency(order.subtotal) }}</td></tr>
                <tr v-if="order.tax_amount"><td>Tax ({{ order.tax_rate }}%)</td><td class="text-right">{{ formatAmountCurrency(order.tax_amount) }}</td></tr>
                <tr v-if="order.discount"><td>Discount</td><td class="text-right">- {{ formatAmountCurrency(order.discount) }}</td></tr>
                <tr v-if="order.shipping"><td>Shipping</td><td class="text-right">{{ formatAmountCurrency(order.shipping) }}</td></tr>
                <tr class="grand-total-row"><td><strong>Grand Total</strong></td><td class="text-right"><strong>{{ formatAmountCurrency(order.total) }}</strong></td></tr>
                <tr><td>Paid Amount</td><td class="text-right">{{ formatAmountCurrency(order.paid_amount) }}</td></tr>
                <tr v-if="order.due_amount"><td>Due Amount</td><td class="text-right">{{ formatAmountCurrency(order.due_amount) }}</td></tr>
            </table>
        </div>
        <div class="amount-words-box" v-if="amountInWords"><strong>Amount in Words:</strong> {{ amountInWords }}</div>
        <div class="summary-box"><span>Total Items: {{ order.total_items }}</span><span>Total Qty: {{ order.total_quantity }}</span></div>
        <div class="payment-box" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment Mode:</strong>
            <span v-for="(payment, pIndex) in order.order_payments" :key="'pay-' + pIndex">
                {{ formatAmountCurrency(payment.amount) }}
                <span v-if="payment.payment && payment.payment.payment_mode">({{ payment.payment.payment_mode.name }})</span>
                <span v-if="pIndex < order.order_payments.length - 1">, </span>
            </span>
        </div>
        <div class="bottom-section">
            <div class="terms-left" v-if="order.terms_condition || (selectedWarehouse && selectedWarehouse.terms_condition)">
                <strong>Terms & Conditions:</strong>
                <p>{{ order.terms_condition || (selectedWarehouse ? selectedWarehouse.terms_condition : '') }}</p>
            </div>
            <div class="signatory-right">
                <p class="for-company">For {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</p>
                <img v-if="selectedWarehouse && selectedWarehouse.signature_url" :src="selectedWarehouse.signature_url" alt="Signature" class="signature-img" />
                <div class="signatory-line"></div>
                <p class="auth-text">Authorized Signatory</p>
            </div>
        </div>
    </div>
</template>

<script>
import { defineComponent } from "vue";
export default defineComponent({
    name: "TallyThemeInvoice",
    props: ["order", "appSetting", "selectedWarehouse", "formatAmountCurrency", "formatDate", "amountInWords"],
});
</script>

<style scoped>
.tally-theme-invoice { width: 100%; font-family: 'Courier New', Courier, monospace; font-size: 11px; color: #1a1a1a; line-height: 1.5; border: 2px solid #1565c0; padding: 8px; }
.invoice-title { text-align: center; margin-bottom: 8px; padding-bottom: 5px; border-bottom: 1px solid #1565c0; }
.invoice-title h3 { margin: 0; font-size: 15px; text-transform: uppercase; letter-spacing: 2px; font-weight: 700; color: #1565c0; }
.company-box { border: 1px solid #bbdefb; padding: 8px; margin-bottom: 8px; background: #f5f9ff; border-radius: 2px; }
.company-box-inner { display: flex; align-items: flex-start; }
.company-logo-section { flex: 0 0 60px; margin-right: 10px; }
.company-logo { max-width: 55px; max-height: 40px; object-fit: contain; }
.company-info-section { flex: 1; }
.company-name { margin: 0 0 3px 0; font-size: 13px; color: #1565c0; font-weight: 700; }
.company-info-section p { margin: 0; font-size: 9px; color: #555; }
.details-box { border: 1px solid #bbdefb; padding: 6px 8px; margin-bottom: 8px; border-radius: 2px; }
.details-table { width: 100%; border-collapse: collapse; }
.details-table td { padding: 2px 4px; font-size: 10px; vertical-align: top; }
.items-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.items-table th { background: #e3f2fd; padding: 5px 6px; font-size: 9px; text-align: left; border: 1px solid #bbdefb; font-weight: 700; text-transform: uppercase; color: #1565c0; letter-spacing: 0.3px; }
.items-table td { padding: 4px 6px; font-size: 10px; border: 1px solid #e0e0e0; vertical-align: top; }
.items-table tbody tr:nth-child(even) { background: #fafafa; }
.text-right { text-align: right; }
.totals-box { margin-bottom: 8px; border-top: 1px solid #1565c0; padding-top: 4px; }
.totals-table { width: 50%; margin-left: auto; border-collapse: collapse; }
.totals-table td { padding: 3px 6px; font-size: 11px; border-bottom: 1px dotted #ddd; }
.grand-total-row td { border-top: 2px solid #1565c0; border-bottom: 2px solid #1565c0; padding: 4px 6px; font-size: 12px; color: #1565c0; }
.amount-words-box { border: 1px solid #bbdefb; padding: 4px 8px; margin-bottom: 8px; font-size: 10px; background: #f5f9ff; border-radius: 2px; }
.summary-box { display: flex; justify-content: space-around; padding: 4px 0; margin-bottom: 6px; font-size: 10px; font-weight: 700; border-top: 1px dashed #90caf9; border-bottom: 1px dashed #90caf9; }
.payment-box { font-size: 10px; padding: 4px 0; margin-bottom: 8px; }
.bottom-section { display: flex; align-items: flex-start; justify-content: space-between; border-top: 1px solid #1565c0; padding-top: 8px; margin-top: 8px; }
.terms-left { flex: 1; font-size: 9px; padding-right: 10px; color: #666; }
.terms-left p { margin: 2px 0 0 0; }
.signatory-right { flex: 0 0 auto; text-align: center; min-width: 120px; }
.signatory-right p { margin: 2px 0; font-size: 10px; }
.for-company { font-weight: 700; color: #1565c0; }
.signature-img { max-width: 90px; max-height: 35px; object-fit: contain; display: block; margin: 4px auto; }
.signatory-line { width: 110px; border-top: 1px solid #333; margin: 4px auto; }
.auth-text { font-size: 9px; }
</style>

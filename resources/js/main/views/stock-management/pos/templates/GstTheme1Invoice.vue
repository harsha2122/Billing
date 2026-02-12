<template>
    <div class="pos-tpl gst-theme1-invoice">
        <div class="header-row">
            <div class="header-company-box">
                <h2 class="company-name">{{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</h2>
                <p>{{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}</p>
                <p v-if="(selectedWarehouse && selectedWarehouse.phone) || (appSetting && appSetting.phone)">Phone: {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}</p>
                <p v-if="(selectedWarehouse && selectedWarehouse.email) || (appSetting && appSetting.email)">Email: {{ selectedWarehouse ? selectedWarehouse.email : appSetting.email }}</p>
                <p v-if="selectedWarehouse && selectedWarehouse.gstin">GSTIN: {{ selectedWarehouse.gstin }}</p>
                <p v-if="selectedWarehouse && selectedWarehouse.state">State: {{ selectedWarehouse.state }} <span v-if="selectedWarehouse.state_code">({{ selectedWarehouse.state_code }})</span></p>
            </div>
            <div class="header-logo-box">
                <img v-if="selectedWarehouse && selectedWarehouse.logo_url" :src="selectedWarehouse.logo_url" :alt="selectedWarehouse.name" class="company-logo" />
            </div>
        </div>
        <div class="invoice-title-bar"><h3>Tax Invoice</h3></div>
        <table class="info-table">
            <tr>
                <td><strong>Invoice #:</strong> {{ order.invoice_number }}</td>
                <td class="text-right"><strong>Date:</strong> {{ formatDate(order.order_date) }}</td>
            </tr>
            <tr>
                <td><strong>Customer:</strong> {{ order.user ? order.user.name : '' }} <span v-if="order.user && order.user.phone"> | {{ order.user.phone }}</span></td>
                <td class="text-right"><span v-if="order.staff_member"><strong>Sold By:</strong> {{ order.staff_member.name }}</span></td>
            </tr>
            <tr v-if="order.user && order.user.tax_number">
                <td colspan="2"><strong>Customer GSTIN:</strong> {{ order.user.tax_number }}</td>
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
        <div class="amount-words" v-if="amountInWords"><strong>Amount in Words:</strong> {{ amountInWords }}</div>
        <div class="totals-section">
            <table class="totals-table">
                <tr><td>Subtotal</td><td class="text-right">{{ formatAmountCurrency(order.subtotal) }}</td></tr>
                <tr v-if="order.tax_amount"><td>Tax ({{ order.tax_rate }}%)</td><td class="text-right">{{ formatAmountCurrency(order.tax_amount) }}</td></tr>
                <tr v-if="order.discount"><td>Discount</td><td class="text-right">- {{ formatAmountCurrency(order.discount) }}</td></tr>
                <tr v-if="order.shipping"><td>Shipping</td><td class="text-right">{{ formatAmountCurrency(order.shipping) }}</td></tr>
                <tr class="grand-total-row"><td><strong>Grand Total</strong></td><td class="text-right"><strong>{{ formatAmountCurrency(order.total) }}</strong></td></tr>
                <tr><td>Paid</td><td class="text-right">{{ formatAmountCurrency(order.paid_amount) }}</td></tr>
                <tr v-if="order.due_amount"><td>Due</td><td class="text-right">{{ formatAmountCurrency(order.due_amount) }}</td></tr>
            </table>
        </div>
        <div class="summary-row"><span>Items: {{ order.total_items }}</span><span>Qty: {{ order.total_quantity }}</span></div>
        <div class="payment-info" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment Mode:</strong>
            <span v-for="(payment, pIndex) in order.order_payments" :key="'pay-' + pIndex">
                {{ formatAmountCurrency(payment.amount) }}
                <span v-if="payment.payment && payment.payment.payment_mode">({{ payment.payment.payment_mode.name }})</span>
                <span v-if="pIndex < order.order_payments.length - 1">, </span>
            </span>
        </div>
        <div class="terms-section" v-if="order.terms_condition || (selectedWarehouse && selectedWarehouse.terms_condition)">
            <strong>Terms & Conditions:</strong>
            <p>{{ order.terms_condition || (selectedWarehouse ? selectedWarehouse.terms_condition : '') }}</p>
        </div>
        <div class="signatory-section">
            <div class="signatory-box">
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
    name: "GstTheme1Invoice",
    props: ["order", "appSetting", "selectedWarehouse", "formatAmountCurrency", "formatDate", "amountInWords"],
});
</script>

<style>
.gst-theme1-invoice { width: 100%; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 11px; color: #1a1a1a; line-height: 1.5; }
.gst-theme1-invoice .header-row { display: flex; align-items: flex-start; margin-bottom: 8px; }
.gst-theme1-invoice .header-company-box { flex: 1; background: #312e81; color: #fff; padding: 10px 12px; border-radius: 3px; }
.gst-theme1-invoice .header-company-box p { margin: 0; font-size: 9px; color: #c7d2fe; }
.gst-theme1-invoice .company-name { margin: 0 0 4px 0; font-size: 14px; color: #fff; font-weight: 700; }
.gst-theme1-invoice .header-logo-box { flex: 0 0 80px; text-align: right; padding-left: 10px; padding-top: 4px; }
.gst-theme1-invoice .company-logo { max-width: 70px; max-height: 50px; object-fit: contain; }
.gst-theme1-invoice .invoice-title-bar { background: #5b57d1; color: #fff; text-align: center; padding: 5px 0; margin-bottom: 8px; }
.gst-theme1-invoice .invoice-title-bar h3 { margin: 0; font-size: 12px; text-transform: uppercase; letter-spacing: 1.5px; font-weight: 600; color: #fff; }
.gst-theme1-invoice .info-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.gst-theme1-invoice .info-table td { padding: 4px 6px; font-size: 10px; border-bottom: 1px solid #f0f0f0; }
.gst-theme1-invoice .text-right { text-align: right; }
.gst-theme1-invoice .items-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.gst-theme1-invoice .items-table thead tr { background: #5b57d1; color: #fff; }
.gst-theme1-invoice .items-table th { padding: 6px; font-size: 9px; text-align: left; font-weight: 600; text-transform: uppercase; letter-spacing: 0.3px; color: #fff; }
.gst-theme1-invoice .items-table td { padding: 5px 6px; font-size: 10px; border-bottom: 1px solid #f0f0f0; }
.gst-theme1-invoice .items-table tbody tr:nth-child(even) { background: #fafafa; }
.gst-theme1-invoice .amount-words { background: #eef2ff; border-left: 3px solid #5b57d1; padding: 5px 8px; margin-bottom: 8px; font-size: 10px; }
.gst-theme1-invoice .totals-section { margin-bottom: 8px; }
.gst-theme1-invoice .totals-table { width: 50%; margin-left: auto; border-collapse: collapse; }
.gst-theme1-invoice .totals-table td { padding: 3px 6px; font-size: 11px; border-bottom: 1px solid #f0f0f0; }
.gst-theme1-invoice .grand-total-row td { border-top: 2px solid #5b57d1; border-bottom: 2px solid #5b57d1; font-size: 12px; padding: 5px 6px; color: #5b57d1; }
.gst-theme1-invoice .summary-row { display: flex; justify-content: space-around; background: #f8f8f8; padding: 4px 0; margin-bottom: 6px; font-size: 10px; font-weight: 600; border-radius: 3px; }
.gst-theme1-invoice .payment-info { font-size: 10px; padding: 4px 0; margin-bottom: 6px; border-bottom: 1px dashed #e0e0e0; }
.gst-theme1-invoice .terms-section { margin-bottom: 10px; font-size: 9px; color: #666; }
.gst-theme1-invoice .terms-section p { margin: 2px 0 0 0; }
.gst-theme1-invoice .signatory-section { text-align: right; margin-top: 14px; }
.gst-theme1-invoice .signatory-box { display: inline-block; text-align: center; border: 1px dashed #ccc; padding: 8px 14px; border-radius: 3px; }
.gst-theme1-invoice .signatory-box p { margin: 2px 0; font-size: 10px; }
.gst-theme1-invoice .for-company { font-weight: 600; color: #5b57d1; }
.gst-theme1-invoice .signature-img { max-width: 100px; max-height: 40px; object-fit: contain; display: block; margin: 4px auto; }
.gst-theme1-invoice .signatory-line { width: 110px; border-top: 1px solid #333; margin: 4px auto; }
</style>

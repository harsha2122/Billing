<template>
    <div class="pos-tpl double-divine-invoice">
        <!-- Header Bar -->
        <div class="header-bar">
            <h2 class="header-company-name">
                {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}
            </h2>
            <span class="header-phone" v-if="(selectedWarehouse && selectedWarehouse.phone) || (appSetting && appSetting.phone)">
                {{ selectedWarehouse ? selectedWarehouse.phone : appSetting.phone }}
            </span>
        </div>

        <!-- Company Details -->
        <div class="company-details">
            <div v-if="selectedWarehouse && selectedWarehouse.logo_url" style="margin-bottom: 4px">
                <img
                    :src="selectedWarehouse.logo_url"
                    :alt="selectedWarehouse.name"
                    class="company-logo"
                />
            </div>
            <p>{{ selectedWarehouse ? selectedWarehouse.address : appSetting.address }}</p>
            <p v-if="(selectedWarehouse && selectedWarehouse.email) || (appSetting && appSetting.email)">
                Email: {{ selectedWarehouse ? selectedWarehouse.email : appSetting.email }}
            </p>
            <p v-if="selectedWarehouse && selectedWarehouse.gstin">GSTIN: {{ selectedWarehouse.gstin }}</p>
        </div>

        <!-- Title -->
        <div class="invoice-title-section">
            <h3 class="invoice-title">Tax Invoice</h3>
            <div class="title-underline"></div>
        </div>

        <!-- Info -->
        <table class="info-table">
            <tr>
                <td><strong>Invoice #:</strong> {{ order.invoice_number }}</td>
                <td class="text-right"><strong>Date:</strong> {{ formatDate(order.order_date) }}</td>
            </tr>
            <tr>
                <td><strong>Customer:</strong> {{ order.user ? order.user.name : '' }}</td>
                <td class="text-right">
                    <span v-if="order.staff_member"><strong>Sold By:</strong> {{ order.staff_member.name }}</span>
                </td>
            </tr>
            <tr v-if="order.user && order.user.phone">
                <td><strong>Phone:</strong> {{ order.user.phone }}</td>
                <td class="text-right">
                    <span v-if="order.user && order.user.tax_number"><strong>GSTIN:</strong> {{ order.user.tax_number }}</span>
                </td>
            </tr>
        </table>

        <!-- Items -->
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width:5%">#</th>
                    <th style="width:30%">Item</th>
                    <th style="width:15%">HSN/SAC</th>
                    <th style="width:12%">Qty</th>
                    <th style="width:18%">Rate</th>
                    <th style="width:20%; text-align:right">Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(item, index) in order.items" :key="index">
                    <td>{{ index + 1 }}</td>
                    <td>{{ item.product ? item.product.name : '' }}</td>
                    <td>{{ item.hsn_sac_code || (item.product ? item.product.hsn_sac_code : '') }}</td>
                    <td>{{ item.quantity }}{{ item.unit ? item.unit.short_name : '' }}</td>
                    <td>{{ formatAmountCurrency(item.single_unit_price) }}</td>
                    <td class="text-right">{{ formatAmountCurrency(item.subtotal) }}</td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="4"></td>
                    <td><strong>Subtotal</strong></td>
                    <td class="text-right">{{ formatAmountCurrency(order.subtotal) }}</td>
                </tr>
                <tr v-if="order.tax_amount">
                    <td colspan="4"></td>
                    <td>Tax</td>
                    <td class="text-right">{{ formatAmountCurrency(order.tax_amount) }}</td>
                </tr>
                <tr v-if="order.discount">
                    <td colspan="4"></td>
                    <td>Discount</td>
                    <td class="text-right">- {{ formatAmountCurrency(order.discount) }}</td>
                </tr>
                <tr v-if="order.shipping">
                    <td colspan="4"></td>
                    <td>Shipping</td>
                    <td class="text-right">{{ formatAmountCurrency(order.shipping) }}</td>
                </tr>
            </tfoot>
        </table>

        <!-- Amount in Words -->
        <div class="amount-words-section" v-if="amountInWords">
            <strong>Amount in Words:</strong> {{ amountInWords }}
        </div>

        <!-- Totals -->
        <div class="totals-box">
            <table class="totals-table">
                <tr class="total-row">
                    <td><strong>Total</strong></td>
                    <td class="text-right"><strong>{{ formatAmountCurrency(order.total) }}</strong></td>
                </tr>
                <tr>
                    <td>Received</td>
                    <td class="text-right">{{ formatAmountCurrency(order.paid_amount) }}</td>
                </tr>
                <tr v-if="order.due_amount">
                    <td><strong>Balance</strong></td>
                    <td class="text-right"><strong>{{ formatAmountCurrency(order.due_amount) }}</strong></td>
                </tr>
            </table>
        </div>

        <!-- Payment -->
        <div class="payment-info" v-if="order.order_payments && order.order_payments.length > 0">
            <strong>Payment:</strong>
            <span v-for="(payment, pIndex) in order.order_payments" :key="'pay-' + pIndex">
                {{ formatAmountCurrency(payment.amount) }}
                <span v-if="payment.payment && payment.payment.payment_mode">({{ payment.payment.payment_mode.name }})</span>
                <span v-if="pIndex < order.order_payments.length - 1">, </span>
            </span>
        </div>

        <!-- Terms -->
        <div class="terms-section" v-if="order.terms_condition || (selectedWarehouse && selectedWarehouse.terms_condition)">
            <strong>Terms & Conditions:</strong>
            <p>{{ order.terms_condition || (selectedWarehouse ? selectedWarehouse.terms_condition : '') }}</p>
        </div>

        <!-- Signatory -->
        <div class="signatory-section">
            <div class="signatory-block">
                <p class="for-company">For {{ selectedWarehouse ? selectedWarehouse.name : appSetting.name }}</p>
                <img v-if="selectedWarehouse && selectedWarehouse.signature_url" :src="selectedWarehouse.signature_url" alt="Signature" class="signature-img" />
                <div class="signatory-line"></div>
                <p>Authorized Signatory</p>
            </div>
        </div>

        <!-- Footer -->
        <div class="footer-bar">
            <p>Thank you for your business!</p>
        </div>
    </div>
</template>

<script>
import { defineComponent } from "vue";
export default defineComponent({
    name: "DoubleDivineInvoice",
    props: ["order", "appSetting", "selectedWarehouse", "formatAmountCurrency", "formatDate", "amountInWords"],
});
</script>

<style>
.double-divine-invoice {
    width: 100%;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    font-size: 11px;
    color: #1a1a1a;
    line-height: 1.5;
}
.double-divine-invoice .header-bar {
    background: #dc3545;
    color: #fff;
    padding: 10px 14px;
    margin-bottom: 8px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.double-divine-invoice .header-company-name { margin: 0; font-size: 16px; font-weight: 700; color: #fff; }
.double-divine-invoice .header-phone { font-size: 11px; opacity: 0.9; }
.double-divine-invoice .company-details { text-align: center; padding: 6px 0; margin-bottom: 6px; }
.double-divine-invoice .company-details p { margin: 1px 0; font-size: 10px; color: #555; }
.double-divine-invoice .company-logo { max-width: 70px; max-height: 45px; object-fit: contain; }
.double-divine-invoice .invoice-title-section { text-align: center; margin-bottom: 8px; }
.double-divine-invoice .invoice-title { margin: 0; font-size: 14px; color: #dc3545; text-transform: uppercase; font-weight: 700; letter-spacing: 1px; }
.double-divine-invoice .title-underline { width: 60px; height: 2px; background: #dc3545; margin: 3px auto 0; }
.double-divine-invoice .info-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.double-divine-invoice .info-table td { padding: 4px 6px; font-size: 10px; border-bottom: 1px solid #f0f0f0; }
.double-divine-invoice .text-right { text-align: right; }
.double-divine-invoice .items-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; }
.double-divine-invoice .items-table thead tr { background: #dc3545; color: #fff; }
.double-divine-invoice .items-table th { padding: 6px; font-size: 9px; text-align: left; font-weight: 600; text-transform: uppercase; letter-spacing: 0.3px; color: #fff; }
.double-divine-invoice .items-table td { padding: 5px 6px; font-size: 10px; border-bottom: 1px solid #f0f0f0; }
.double-divine-invoice .items-table tbody tr:nth-child(even) { background: #fafafa; }
.double-divine-invoice .items-table tfoot td { border: none; border-top: 1px solid #f0f0f0; padding: 3px 6px; font-size: 10px; }
.double-divine-invoice .amount-words-section { background: #fef2f2; border-left: 3px solid #dc3545; padding: 5px 8px; margin-bottom: 8px; font-size: 10px; }
.double-divine-invoice .totals-box { border: 1px solid #dc3545; border-radius: 4px; padding: 6px 10px; margin-bottom: 8px; }
.double-divine-invoice .totals-table { width: 100%; border-collapse: collapse; }
.double-divine-invoice .totals-table td { padding: 4px 0; font-size: 11px; }
.double-divine-invoice .total-row td { font-size: 13px; color: #dc3545; border-bottom: 1px solid #f0f0f0; padding-bottom: 5px; }
.double-divine-invoice .payment-info { font-size: 10px; padding: 5px 0; margin-bottom: 6px; border-bottom: 1px dashed #e0e0e0; }
.double-divine-invoice .terms-section { margin-bottom: 10px; font-size: 9px; color: #666; }
.double-divine-invoice .terms-section p { margin: 2px 0 0 0; }
.double-divine-invoice .signatory-section { text-align: right; margin-top: 14px; }
.double-divine-invoice .signatory-block { display: inline-block; text-align: center; }
.double-divine-invoice .signatory-block p { margin: 2px 0; font-size: 10px; }
.double-divine-invoice .for-company { font-weight: 600; }
.double-divine-invoice .signature-img { max-width: 100px; max-height: 40px; object-fit: contain; display: block; margin: 4px auto; }
.double-divine-invoice .signatory-line { width: 120px; border-top: 1px solid #333; margin: 4px auto; }
.double-divine-invoice .footer-bar { background: #dc3545; color: #fff; text-align: center; padding: 5px 0; margin-top: 10px; }
.double-divine-invoice .footer-bar p { margin: 0; font-size: 10px; letter-spacing: 0.3px; color: #fff; }
</style>

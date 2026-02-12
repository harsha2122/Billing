<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>{{ $order->invoice_number }}</title>

    <style>
        @page {
            margin: 15px;
            size: A4 portrait;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: DejaVu Sans, sans-serif;
            font-size: 11px;
            color: #333;
            line-height: 1.4;
            background: #fff;
        }

        .invoice-wrapper {
            max-width: 780px;
            margin: 0 auto;
            padding: 10px;
        }

        .accent { color: #dc3545; }
        .accent-bg { background-color: #dc3545; color: #fff; }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        .text-left { text-align: left; }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .font-bold { font-weight: bold; }
        .font-sm { font-size: 10px; }

        .mt-5 { margin-top: 5px; }
        .mt-10 { margin-top: 10px; }
        .mt-15 { margin-top: 15px; }
        .mb-5 { margin-bottom: 5px; }

        /* Header band */
        .header-band {
            background-color: #dc3545;
            color: #fff;
            padding: 12px 15px;
        }

        .header-band .company-name {
            font-size: 22px;
            font-weight: bold;
        }

        .header-band .company-phone {
            font-size: 12px;
            margin-top: 2px;
        }

        .invoice-title {
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            color: #dc3545;
            padding: 10px 0;
            border-bottom: 2px solid #dc3545;
            margin-bottom: 10px;
        }

        .info-section {
            margin-bottom: 10px;
        }

        .info-section .label {
            font-weight: bold;
            color: #dc3545;
            font-size: 12px;
            margin-bottom: 3px;
        }

        .items-table {
            margin-top: 10px;
            border: 1px solid #ddd;
        }

        .items-table th {
            background-color: #dc3545;
            color: #fff;
            padding: 7px 6px;
            font-size: 11px;
            text-align: center;
            border-right: 1px solid rgba(255,255,255,0.2);
        }

        .items-table th:last-child {
            border-right: none;
        }

        .items-table td {
            padding: 6px;
            border-bottom: 1px solid #eee;
            border-right: 1px solid #eee;
            font-size: 11px;
            text-align: center;
        }

        .items-table td:last-child {
            border-right: none;
        }

        .items-table .total-row td {
            background-color: #fce4e6;
            font-weight: bold;
            border-top: 2px solid #dc3545;
        }

        .amount-words-box {
            background-color: #fce4e6;
            border: 1px solid #dc3545;
            padding: 8px 12px;
            margin-top: 10px;
            font-size: 11px;
        }

        .totals-section {
            margin-top: 10px;
        }

        .totals-section table {
            width: 50%;
            float: right;
        }

        .totals-section .totals-header {
            background-color: #dc3545;
            color: #fff;
            font-weight: bold;
        }

        .totals-section td {
            padding: 5px 10px;
            font-size: 11px;
        }

        .totals-section .total-label {
            text-align: left;
            font-weight: bold;
            width: 50%;
        }

        .totals-section .total-value {
            text-align: right;
            width: 50%;
        }

        .totals-section tr:nth-child(even) {
            background-color: #fce4e6;
        }

        .terms-section {
            margin-top: 15px;
            font-size: 10px;
            clear: both;
        }

        .terms-section .terms-title {
            font-weight: bold;
            color: #dc3545;
            font-size: 11px;
            margin-bottom: 3px;
        }

        .signature-section {
            margin-top: 30px;
            text-align: right;
        }

        .signature-box {
            display: inline-block;
            text-align: center;
            min-width: 200px;
        }

        .signature-line {
            border-top: 1px solid #dc3545;
            margin-top: 5px;
            padding-top: 5px;
            font-weight: bold;
            font-size: 11px;
        }

        .clearfix::after {
            content: "";
            display: table;
            clear: both;
        }
    </style>
</head>

<body>
    <div class="invoice-wrapper">

        {{-- RED HEADER BAND --}}
        <div class="header-band">
            <table>
                <tr>
                    <td style="width: 15%; vertical-align: middle;">
                        @if($order->warehouse && $order->warehouse->logo_url)
                            <img src="{{ $order->warehouse->logo_url }}" style="max-width: 80px; max-height: 50px;" />
                        @elseif($company->light_logo_url)
                            <img src="{{ $company->light_logo_url }}" style="max-width: 80px; max-height: 50px;" />
                        @endif
                    </td>
                    <td style="vertical-align: middle;">
                        <div class="company-name">{{ $order->warehouse ? $order->warehouse->name : $company->name }}</div>
                        @if($order->warehouse ? $order->warehouse->address : $company->address)
                            <div class="company-phone">{{ $order->warehouse ? $order->warehouse->address : $company->address }}</div>
                        @endif
                        @if($order->warehouse ? $order->warehouse->phone : $company->phone)
                            <div class="company-phone">{{ $traslations['phone'] ?? 'Phone' }}: {{ $order->warehouse ? $order->warehouse->phone : $company->phone }}</div>
                        @endif
                    </td>
                    <td style="width: 25%; text-align: right; vertical-align: middle;">
                        @if($order->warehouse ? $order->warehouse->email : $company->email)
                            <div style="font-size: 11px;">{{ $order->warehouse ? $order->warehouse->email : $company->email }}</div>
                        @endif
                    </td>
                </tr>
            </table>
        </div>

        {{-- TAX INVOICE TITLE --}}
        <div class="invoice-title">{{ $traslations['tax_invoice'] ?? 'Tax Invoice' }}</div>

        {{-- BILL TO + INVOICE DETAILS --}}
        <table class="info-section">
            <tr>
                <td style="width: 55%; vertical-align: top;">
                    <div class="label">{{ $traslations['bill_to'] ?? 'Bill To' }}:</div>
                    <div class="font-bold" style="font-size: 13px;">{{ $order->user->name }}</div>
                    @if($order->user->address)
                        <div>{{ $order->user->address }}</div>
                    @endif
                    @if($order->user->phone)
                        <div>{{ $traslations['contact_no'] ?? 'Contact No' }}: {{ $order->user->phone }}</div>
                    @endif
                    @if($order->user->email)
                        <div>{{ $traslations['email'] ?? 'Email' }}: {{ $order->user->email }}</div>
                    @endif
                    @if($order->user->tax_number)
                        <div>GSTIN: {{ $order->user->tax_number }}</div>
                    @endif
                </td>
                <td style="width: 45%; vertical-align: top; text-align: right;">
                    <div>
                        <span class="font-bold accent">{{ $traslations['invoice'] ?? 'Invoice' }} No:</span>
                        {{ $order->invoice_number }}
                    </div>
                    <div>
                        <span class="font-bold accent">{{ $traslations['order_date'] ?? 'Date' }}:</span>
                        {{ $order->order_date->format($dateTimeFormat) }}
                    </div>
                    @if($order->staffMember)
                        <div>
                            <span class="font-bold accent">{{ $traslations['staff_member'] ?? 'Staff' }}:</span>
                            {{ $order->staffMember->name }}
                        </div>
                    @endif
                </td>
            </tr>
        </table>

        {{-- ITEMS TABLE --}}
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width: 6%;">#</th>
                    <th style="width: 32%;">{{ $traslations['product'] ?? 'Item Name' }}</th>
                    <th style="width: 12%;">HSN/SAC</th>
                    <th style="width: 12%;">{{ $traslations['quantity'] ?? 'Quantity' }}</th>
                    <th style="width: 18%;">{{ $traslations['unit_price'] ?? 'Price/Unit' }}</th>
                    <th style="width: 20%;">{{ $traslations['total'] ?? 'Amount' }}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($order->items as $item)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td class="text-left" style="padding-left: 8px;">{{ $item->product->name }}</td>
                        <td>{{ $item->hsn_sac_code ?? $item->product->hsn_sac_code ?? '-' }}</td>
                        <td>{{ $item->quantity }} {{ $item->unit->short_name }}</td>
                        <td class="text-right">{{ $company->currency->symbol }}{{ $item->single_unit_price }}</td>
                        <td class="text-right">{{ $company->currency->symbol }}{{ $item->subtotal }}</td>
                    </tr>
                @endforeach

                <tr class="total-row">
                    <td colspan="5" class="text-right font-bold">{{ $traslations['total'] ?? 'Total' }}</td>
                    <td class="text-right">{{ $company->currency->symbol }}{{ number_format($order->total, 2) }}</td>
                </tr>
            </tbody>
        </table>

        {{-- INVOICE AMOUNT IN WORDS --}}
        <div class="amount-words-box">
            <span class="font-bold accent">{{ $traslations['amount_in_words'] ?? 'Invoice Amount in Words' }}:</span>
            {{ $amountInWords }}
        </div>

        {{-- TOTALS --}}
        <div class="totals-section clearfix">
            <table>
                <tr class="totals-header">
                    <td class="total-label">{{ $traslations['description'] ?? 'Description' }}</td>
                    <td class="total-value">{{ $traslations['total'] ?? 'Amount' }}</td>
                </tr>
                <tr>
                    <td class="total-label">{{ $traslations['subtotal'] ?? 'Sub Total' }}</td>
                    <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->subtotal, 2) }}</td>
                </tr>
                @if($order->tax_amount > 0)
                    <tr>
                        <td class="total-label">{{ $traslations['tax'] ?? 'Tax' }} ({{ $order->tax_rate }}%)</td>
                        <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->tax_amount, 2) }}</td>
                    </tr>
                @endif
                @if($order->discount > 0)
                    <tr>
                        <td class="total-label">{{ $traslations['discount'] ?? 'Discount' }}</td>
                        <td class="total-value">- {{ $company->currency->symbol }}{{ number_format($order->discount, 2) }}</td>
                    </tr>
                @endif
                @if($order->shipping > 0)
                    <tr>
                        <td class="total-label">{{ $traslations['shipping'] ?? 'Shipping' }}</td>
                        <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->shipping, 2) }}</td>
                    </tr>
                @endif
                <tr style="background-color: #dc3545; color: #fff;">
                    <td class="total-label">{{ $traslations['total'] ?? 'Total' }}</td>
                    <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->total, 2) }}</td>
                </tr>
                <tr>
                    <td class="total-label">{{ $traslations['paid_amount'] ?? 'Received' }}</td>
                    <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->paid_amount, 2) }}</td>
                </tr>
                <tr>
                    <td class="total-label">{{ $traslations['due_amount'] ?? 'Balance' }}</td>
                    <td class="total-value">{{ $company->currency->symbol }}{{ number_format($order->due_amount, 2) }}</td>
                </tr>
            </table>
        </div>

        <div class="clearfix"></div>

        {{-- TERMS & CONDITIONS + SIGNATORY --}}
        <table style="margin-top: 20px;">
            <tr>
                <td style="width: 55%; vertical-align: top;">
                    @php
                        $terms = $order->terms_condition ?? ($order->warehouse ? $order->warehouse->terms_condition : '');
                    @endphp
                    @if($terms)
                        <div class="terms-section" style="margin-top: 0;">
                            <div class="terms-title">{{ $traslations['terms_conditions'] ?? 'Terms & Conditions' }}:</div>
                            <div>{!! nl2br(e($terms)) !!}</div>
                        </div>
                    @endif
                </td>
                <td style="width: 45%; text-align: right; vertical-align: bottom;">
                    <div class="signature-box">
                        <div class="font-bold accent" style="margin-bottom: 5px;">For {{ $order->warehouse ? $order->warehouse->name : $company->name }}</div>
                        @if($order->warehouse && $order->warehouse->signature)
                            <img src="{{ $order->warehouse->signature_url }}" style="max-width: 150px; max-height: 60px;" />
                            <br>
                        @else
                            <div style="height: 50px;"></div>
                        @endif
                        <div class="signature-line">{{ $traslations['authorized_signatory'] ?? 'Authorized Signatory' }}</div>
                    </div>
                </td>
            </tr>
        </table>

    </div>
</body>

</html>

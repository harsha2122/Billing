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

        .accent { color: #5b57d1; }
        .accent-bg { background-color: #5b57d1; color: #fff; }

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

        /* Company info dark box top-left */
        .header-dark-box {
            background-color: #2d2a6e;
            color: #fff;
            padding: 12px 15px;
            border-radius: 0;
        }

        .header-dark-box .company-name {
            font-size: 20px;
            font-weight: bold;
        }

        .header-dark-box .company-details {
            font-size: 11px;
            margin-top: 3px;
            opacity: 0.9;
        }

        /* Tax Invoice centered */
        .invoice-title {
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            color: #5b57d1;
            padding: 10px 0;
            border-bottom: 2px solid #5b57d1;
            border-top: 2px solid #5b57d1;
            margin: 10px 0;
        }

        /* Bill To / Invoice Details */
        .info-label {
            font-weight: bold;
            color: #5b57d1;
            font-size: 12px;
            margin-bottom: 4px;
            padding-bottom: 3px;
            border-bottom: 1px solid #d4d2f7;
        }

        .info-content {
            padding: 5px 0;
        }

        /* Items table */
        .items-table {
            margin-top: 10px;
            border: 1px solid #d4d2f7;
        }

        .items-table th {
            background-color: #5b57d1;
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
            border-bottom: 1px solid #ebebff;
            border-right: 1px solid #ebebff;
            font-size: 11px;
            text-align: center;
        }

        .items-table td:last-child {
            border-right: none;
        }

        .items-table .total-row td {
            background-color: #f0efff;
            font-weight: bold;
            border-top: 2px solid #5b57d1;
        }

        /* Amount in words */
        .amount-words-box {
            background-color: #f0efff;
            border: 1px solid #5b57d1;
            padding: 8px 12px;
            font-size: 11px;
            margin-top: 10px;
        }

        /* Totals */
        .totals-table {
            margin-top: 10px;
            width: 45%;
            float: right;
        }

        .totals-table td {
            padding: 5px 10px;
            font-size: 11px;
        }

        .totals-table .total-label {
            text-align: left;
            font-weight: bold;
            width: 55%;
        }

        .totals-table .total-value {
            text-align: right;
            width: 45%;
        }

        .totals-table .grand-total td {
            background-color: #5b57d1;
            color: #fff;
            font-weight: bold;
        }

        .totals-table tr:nth-child(even):not(.grand-total) {
            background-color: #f5f4ff;
        }

        .terms-section {
            margin-top: 12px;
            font-size: 10px;
            clear: both;
        }

        .terms-title {
            font-weight: bold;
            color: #5b57d1;
            font-size: 11px;
            margin-bottom: 3px;
        }

        /* Dashed signature box */
        .signature-box-dashed {
            border: 1px dashed #5b57d1;
            padding: 10px;
            text-align: center;
            min-width: 200px;
            display: inline-block;
        }

        .signature-label {
            font-weight: bold;
            font-size: 11px;
            color: #5b57d1;
            margin-top: 5px;
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

        {{-- HEADER: Company dark box left, Logo right --}}
        <table>
            <tr>
                <td style="width: 65%; vertical-align: top; padding-right: 10px;">
                    <div class="header-dark-box">
                        <div class="company-name">{{ $company->name }}</div>
                        <div class="company-details">
                            @if($company->address)
                                {{ $company->address }}<br>
                            @endif
                            @if($company->phone)
                                {{ $traslations['phone'] ?? 'Phone' }}: {{ $company->phone }}
                            @endif
                            @if($company->email)
                                | {{ $company->email }}
                            @endif
                            @if($company->gstin)
                                <br>GSTIN: {{ $company->gstin }}
                            @endif
                        </div>
                    </div>
                </td>
                <td style="width: 35%; text-align: right; vertical-align: middle;">
                    @if($company->light_logo_url)
                        <img src="{{ $company->light_logo_url }}" style="max-width: 150px; max-height: 70px;" />
                    @endif
                </td>
            </tr>
        </table>

        {{-- TAX INVOICE TITLE --}}
        <div class="invoice-title">{{ $traslations['tax_invoice'] ?? 'Tax Invoice' }}</div>

        {{-- BILL TO left, INVOICE DETAILS right --}}
        <table style="margin-top: 5px;">
            <tr>
                <td style="width: 50%; vertical-align: top; padding-right: 15px;">
                    <div class="info-label">{{ $traslations['bill_to'] ?? 'Bill To' }}</div>
                    <div class="info-content">
                        <div class="font-bold" style="font-size: 13px;">{{ $order->user->name }}</div>
                        @if($order->user->address)
                            <div>{{ $order->user->address }}</div>
                        @endif
                        @if($order->user->phone)
                            <div>{{ $traslations['phone'] ?? 'Phone' }}: {{ $order->user->phone }}</div>
                        @endif
                        @if($order->user->email)
                            <div>{{ $traslations['email'] ?? 'Email' }}: {{ $order->user->email }}</div>
                        @endif
                        @if($order->user->tax_number)
                            <div class="font-bold">GSTIN: {{ $order->user->tax_number }}</div>
                        @endif
                    </div>
                </td>
                <td style="width: 50%; vertical-align: top; padding-left: 15px;">
                    <div class="info-label">{{ $traslations['invoice_details'] ?? 'Invoice Details' }}</div>
                    <div class="info-content">
                        <div>
                            <span class="font-bold">{{ $traslations['invoice'] ?? 'Invoice' }} No:</span>
                            {{ $order->invoice_number }}
                        </div>
                        <div>
                            <span class="font-bold">{{ $traslations['order_date'] ?? 'Date' }}:</span>
                            {{ $order->order_date->format($dateTimeFormat) }}
                        </div>
                        @if($order->staffMember)
                            <div>
                                <span class="font-bold">{{ $traslations['staff_member'] ?? 'Staff' }}:</span>
                                {{ $order->staffMember->name }}
                            </div>
                        @endif
                        @if($order->warehouse)
                            <div>
                                <span class="font-bold">{{ $traslations['warehouse'] ?? 'Warehouse' }}:</span>
                                {{ $order->warehouse->name }}
                            </div>
                        @endif
                    </div>
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
        <table class="totals-table">
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
            <tr class="grand-total">
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
                    <div class="signature-box-dashed">
                        <div class="font-bold accent" style="margin-bottom: 5px;">For {{ $company->name }}</div>
                        @if($order->warehouse && $order->warehouse->signature)
                            <img src="{{ $order->warehouse->signature_url }}" style="max-width: 140px; max-height: 55px;" />
                            <br>
                        @else
                            <div style="height: 45px;"></div>
                        @endif
                        <div class="signature-label">{{ $traslations['authorized_signatory'] ?? 'Authorized Signatory' }}</div>
                    </div>
                </td>
            </tr>
        </table>

    </div>
</body>

</html>

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

        .accent { color: #6c63ff; }
        .accent-bg { background-color: #6c63ff; color: #fff; }

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

        /* Tax Invoice title centered */
        .invoice-title-top {
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            color: #6c63ff;
            padding: 8px 0;
            border-bottom: 3px solid #6c63ff;
            margin-bottom: 10px;
        }

        /* Header with logo left, company info right in box */
        .header-section {
            margin-bottom: 10px;
        }

        .company-box {
            border: 2px solid #6c63ff;
            border-radius: 4px;
            padding: 10px;
            text-align: right;
        }

        .company-box .company-name {
            font-size: 18px;
            font-weight: bold;
            color: #6c63ff;
        }

        /* Purple band section titles */
        .section-band {
            background-color: #6c63ff;
            color: #fff;
            padding: 5px 10px;
            font-weight: bold;
            font-size: 12px;
        }

        .section-content {
            border: 1px solid #d0ceff;
            border-top: none;
            padding: 8px 10px;
            min-height: 70px;
        }

        /* Items table */
        .items-table {
            margin-top: 10px;
            border: 1px solid #d0ceff;
        }

        .items-table th {
            background-color: #6c63ff;
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
            border-bottom: 1px solid #e8e7ff;
            border-right: 1px solid #e8e7ff;
            font-size: 11px;
            text-align: center;
        }

        .items-table td:last-child {
            border-right: none;
        }

        .items-table .total-row td {
            background-color: #f0efff;
            font-weight: bold;
            border-top: 2px solid #6c63ff;
        }

        /* Amounts section */
        .amounts-table {
            margin-top: 10px;
            width: 45%;
            float: right;
        }

        .amounts-table td {
            padding: 5px 10px;
            font-size: 11px;
        }

        .amounts-table .amt-label {
            text-align: left;
            font-weight: bold;
            width: 55%;
        }

        .amounts-table .amt-value {
            text-align: right;
            width: 45%;
        }

        .amounts-table .grand-total td {
            background-color: #6c63ff;
            color: #fff;
            font-weight: bold;
        }

        /* Amount in words band */
        .amount-words-band {
            background-color: #6c63ff;
            color: #fff;
            padding: 8px 12px;
            font-size: 11px;
            margin-top: 10px;
            clear: both;
        }

        .terms-section {
            margin-top: 12px;
            font-size: 10px;
        }

        .terms-title {
            font-weight: bold;
            color: #6c63ff;
            font-size: 11px;
            margin-bottom: 3px;
        }

        .signature-box {
            text-align: center;
            min-width: 180px;
            display: inline-block;
        }

        .signature-line {
            border-top: 1px dashed #6c63ff;
            margin-top: 5px;
            padding-top: 5px;
            font-weight: bold;
            font-size: 11px;
            color: #6c63ff;
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

        {{-- TAX INVOICE TITLE AT TOP --}}
        <div class="invoice-title-top">{{ $traslations['tax_invoice'] ?? 'Tax Invoice' }}</div>

        {{-- HEADER: Logo left, Company box right --}}
        <div class="header-section">
            <table>
                <tr>
                    <td style="width: 30%; vertical-align: middle;">
                        @if($order->warehouse && $order->warehouse->logo_url)
                            <img src="{{ $order->warehouse->logo_url }}" style="max-width: 140px; max-height: 70px;" />
                        @elseif($company->light_logo_url)
                            <img src="{{ $company->light_logo_url }}" style="max-width: 140px; max-height: 70px;" />
                        @endif
                    </td>
                    <td style="width: 70%; vertical-align: middle;">
                        <div class="company-box">
                            <div class="company-name">{{ $order->warehouse ? $order->warehouse->name : $company->name }}</div>
                            @php
                                $displayAddress = $order->warehouse ? $order->warehouse->address : $company->address;
                                $displayPhone = $order->warehouse ? $order->warehouse->phone : $company->phone;
                                $displayEmail = $order->warehouse ? $order->warehouse->email : $company->email;
                            @endphp
                            @if($displayAddress)
                                <div style="margin-top: 3px;">{{ $displayAddress }}</div>
                            @endif
                            <div>
                                @if($displayPhone)
                                    {{ $traslations['phone'] ?? 'Phone' }}: {{ $displayPhone }}
                                @endif
                                @if($displayEmail)
                                    | {{ $displayEmail }}
                                @endif
                            </div>
                            @if($order->warehouse && $order->warehouse->gstin)
                                <div class="font-bold">GSTIN: {{ $order->warehouse->gstin }}</div>
                            @elseif($company->gstin)
                                <div class="font-bold">GSTIN: {{ $company->gstin }}</div>
                            @endif
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        {{-- BILL TO (left) + INVOICE DETAILS (right) --}}
        <table>
            <tr>
                <td style="width: 50%; vertical-align: top; padding-right: 8px;">
                    <div class="section-band">{{ $traslations['bill_to'] ?? 'Bill To' }}</div>
                    <div class="section-content">
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
                <td style="width: 50%; vertical-align: top; padding-left: 8px;">
                    <div class="section-band">{{ $traslations['invoice_details'] ?? 'Invoice Details' }}</div>
                    <div class="section-content">
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

        {{-- AMOUNTS SECTION --}}
        <table class="amounts-table">
            <tr>
                <td class="amt-label">{{ $traslations['subtotal'] ?? 'Sub Total' }}</td>
                <td class="amt-value">{{ $company->currency->symbol }}{{ number_format($order->subtotal, 2) }}</td>
            </tr>
            @if($order->tax_amount > 0)
                <tr>
                    <td class="amt-label">{{ $traslations['tax'] ?? 'Tax' }} ({{ $order->tax_rate }}%)</td>
                    <td class="amt-value">{{ $company->currency->symbol }}{{ number_format($order->tax_amount, 2) }}</td>
                </tr>
            @endif
            @if($order->discount > 0)
                <tr>
                    <td class="amt-label">{{ $traslations['discount'] ?? 'Discount' }}</td>
                    <td class="amt-value">- {{ $company->currency->symbol }}{{ number_format($order->discount, 2) }}</td>
                </tr>
            @endif
            @if($order->shipping > 0)
                <tr>
                    <td class="amt-label">{{ $traslations['shipping'] ?? 'Shipping' }}</td>
                    <td class="amt-value">{{ $company->currency->symbol }}{{ number_format($order->shipping, 2) }}</td>
                </tr>
            @endif
            <tr class="grand-total">
                <td class="amt-label">{{ $traslations['total'] ?? 'Total' }}</td>
                <td class="amt-value">{{ $company->currency->symbol }}{{ number_format($order->total, 2) }}</td>
            </tr>
            <tr>
                <td class="amt-label">{{ $traslations['paid_amount'] ?? 'Received' }}</td>
                <td class="amt-value">{{ $company->currency->symbol }}{{ number_format($order->paid_amount, 2) }}</td>
            </tr>
            <tr>
                <td class="amt-label">{{ $traslations['due_amount'] ?? 'Balance' }}</td>
                <td class="amt-value">{{ $company->currency->symbol }}{{ number_format($order->due_amount, 2) }}</td>
            </tr>
        </table>

        <div class="clearfix"></div>

        {{-- INVOICE AMOUNT IN WORDS (PURPLE BAND) --}}
        <div class="amount-words-band">
            <span class="font-bold">{{ $traslations['amount_in_words'] ?? 'Invoice Amount in Words' }}:</span>
            {{ $amountInWords }}
        </div>

        {{-- TERMS & CONDITIONS + SIGNATORY --}}
        <table style="margin-top: 15px;">
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

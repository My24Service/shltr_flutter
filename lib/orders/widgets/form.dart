import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:my24_flutter_orders/widgets/form/order.dart';

import '../../company/api/company_api.dart';

class OrderFormWidget<OrderBloc, OrderFormData> extends BaseOrderFormWidget {
  final CompanyApi companyApi = CompanyApi();

  OrderFormWidget({
    super.key,
    required super.orderPageMetaData,
    required super.formData,
    required super.fetchEvent,
    required super.widgetsIn
  });

  TableRow _getBranchTypeAhead(BuildContext context) {
    return TableRow(
        children: [
          Padding(padding: const EdgeInsets.only(top: 16),
              child: Text(
                  i18nIn.$trans('form.label_search_branch'),
                  style: const TextStyle(fontWeight: FontWeight.bold)
              )
          ),
          TypeAheadFormField<dynamic>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: formData!.typeAheadControllerBranch,
              decoration: InputDecoration(
                  labelText: i18nIn.$trans('form.typeahead_label_search_branch')
              ),
            ),
            suggestionsCallback: (pattern) async {
              return await companyApi.branchTypeAhead(pattern);
            },
            itemBuilder: (context, dynamic suggestion) {
              return ListTile(
                title: Text(suggestion.value),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (branch) {
              formData!.typeAheadControllerBranch!.text = '';

              // fill fields
              formData!.branch = branch.id;
              formData!.orderNameController!.text = branch.name!;
              formData!.orderAddressController!.text = branch.address!;
              formData!.orderPostalController!.text = branch.postal!;
              formData!.orderCityController!.text = branch.city!;
              formData!.orderCountryCode = branch.countryCode;
              formData!.orderTelController!.text = branch.tel!;
              formData!.orderMobileController!.text = branch.mobile!;
              formData!.orderEmailController!.text = branch.email!;
              formData!.orderContactController!.text = branch.contact!;

              updateFormData(context);
            },
            validator: (value) {
              return null;
            },
            onSaved: (value) => {

            },
          )
        ]
    );
  }

  TableRow _getBranchNameTextField() {
    return const TableRow(
        children: [
          SizedBox(height: 1),
          SizedBox(height: 1),
        ]
    );
  }

  @override
  TableRow getFirstElement(BuildContext context) {
    if (isPlanning() && formData!.id == null) {
        return _getBranchTypeAhead(context);
    }

    return _getBranchNameTextField();
  }
}

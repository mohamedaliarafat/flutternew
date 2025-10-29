import 'package:flutter/material.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/address_response.dart';
import 'package:foodly/views/profile/widget/address_tile.dart' show AddressTile, AddressesPage;


class AddressListWidget extends StatelessWidget {
  final List<AddressResponse> addresses;
  final void Function(AddressResponse) onAddressSelected;
  final void Function(AddressResponse)? onEdit; // جديد

  const AddressListWidget({
    super.key,
    required this.addresses,
    required this.onAddressSelected,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: addresses.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final address = addresses[index];
        return ListTile(
          title: Text(address.addressLine1),
          subtitle: Text(address.postalCode),
          onTap: () => onAddressSelected(address),
          trailing: onEdit != null
              ? IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEdit!(address),
                )
              : null,
        );
      },
    );
  }
}

import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/text_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BirthWeightInput extends StatefulWidget {
  const BirthWeightInput({
    required this.state,
    super.key,
  });
  final BabyState state;

  @override
  // ignore: library_private_types_in_public_api
  _BirthWeightInputState createState() => _BirthWeightInputState();
}

class _BirthWeightInputState extends State<BirthWeightInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.state.birthWeight?.value?.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      var currentValue = int.parse(_controller.text);
      currentValue++;
      _controller.text = currentValue.toString();
      context.read<BabyBloc>().add(BabyEventBirthWeightChanged(currentValue));
    });
  }

  void _decrement() {
    setState(() {
      var currentValue = int.parse(_controller.text);
      currentValue--;
      _controller.text = (currentValue > 0 ? currentValue : 0).toString();
      context.read<BabyBloc>().add(BabyEventBirthWeightChanged(currentValue));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const HeaderText(title: 'Ağırlık(gram):'),
                Container(
                  width: 100,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: const Border(
                      bottom: BorderSide(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          controller: _controller,
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            context.read<BabyBloc>().add(
                                  BabyEventBirthWeightChanged(
                                    int.parse(_controller.text),
                                  ),
                                );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 38,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: _increment,
                              child: const Icon(
                                Icons.arrow_drop_up,
                                size: 18,
                              ),
                            ),
                            InkWell(
                              onTap: _decrement,
                              child: const Icon(
                                Icons.arrow_drop_down,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.state.birthWeight?.errorMessage != null &&
                widget.state.birthWeight!.errorMessage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  widget.state.birthWeight!.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

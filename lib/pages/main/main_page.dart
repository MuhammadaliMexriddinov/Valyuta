
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/model/currency_model.dart';
import '../../widget/itemWidget.dart';
import 'bloc/main_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController itemOneController = TextEditingController();
  TextEditingController itemTwoController = TextEditingController();
  bool items = true;
  int _selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    print("3123123");
    final bloc = context.read<MainBloc>();
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => context.setLocale(const Locale("uz", "UZ")),
          // ),
          appBar: AppBar(
            backgroundColor: Colors.deepPurple.shade500,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            title: Text(
              "valyuta",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            actions: [
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 30),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    bloc.add(MainGetDateEvent(date));
                  }
                },
                child: const Icon(
                  Icons.calendar_month,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    isDismissible: false,
                    isScrollControlled: true,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return SizedBox(
                          height: 300,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 13,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade300),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  RadioListTile<int>(
                                    title: Text("O'zbekcha"),
                                    value: 1,
                                    groupValue: _selectedValue,
                                    onChanged: (int? value) {
                                      setState(() => _selectedValue = value!);
                                      context
                                          .setLocale(const Locale("uz", "UZ"));
                                    },
                                  ),
                                  RadioListTile<int>(
                                    title: Text("Узбекча"),
                                    value: 2,
                                    groupValue: _selectedValue,
                                    onChanged: (int? value) {
                                      context
                                          .setLocale(const Locale("uz", "UZC"));
                                      setState(() => _selectedValue = value!);
                                    },
                                  ),
                                  RadioListTile<int>(
                                    title: Text("Русский"),
                                    value: 3,
                                    groupValue: _selectedValue,
                                    onChanged: (int? value) {
                                      context
                                          .setLocale(const Locale("ru", "RU"));
                                      setState(() => _selectedValue = value!);
                                    },
                                  ),
                                  RadioListTile<int>(
                                    title: Text('English'),
                                    value: 4,
                                    groupValue: _selectedValue,
                                    onChanged: (int? value) {
                                      context
                                          .setLocale(const Locale("en", "EN"));
                                      setState(() => _selectedValue = value!);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                    },
                  );
                },
                child: const Icon(
                  Icons.g_translate_outlined,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state.status == Status.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.separated(
                itemCount: state.currencies.length,
                separatorBuilder: (_, i) => const SizedBox(height: 1),
                itemBuilder: (_, i) {
                  final model = state.currencies[i].tr(context.locale);
                  return ItemWidget(model: model);
                },
              );
            },
          ),
        );
      },
    );
  }

  smallItem(CurrencyModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          //     boxShadow: const [
          //   BoxShadow(color: Colors.black26,)
          // ]
        ),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: const BorderSide(color: Colors.black)),
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              model.ccyNm,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "  +${model.diff}",
                              style: TextStyle(
                                  color: Colors.greenAccent.shade200,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        Text(
                          "${model.nominal} ${model.ccy} => ${model.rate} UZS | "
                          "${model.date}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                items = !items;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              size: 40,
                            ))
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }
}

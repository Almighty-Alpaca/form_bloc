import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

class _FakeFormBloc extends FormBloc<dynamic, dynamic> {
  @override
  void onSubmitting() {}
}

void main() {
  group('ListFieldBloc:', () {
    group('removeWhere', () {
      test('by name', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
            fieldBlocs: [boolean1, boolean2], name: 'list');

        final expected = ListFieldBlocState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean2],
          formBloc: null,
          extraData: null,
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.removeFieldBlocsWhere((element) => element.state.name == '1');
      });
    });

    group('removeAt', () {
      test('remove at i', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
            fieldBlocs: [boolean1, boolean2], name: 'list');

        final expected = ListFieldBlocState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1],
          formBloc: null,
          extraData: null,
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.removeFieldBlocAt(1);
      });
    });

    group('addFieldBloc', () {
      test('add', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');

        final list =
            ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(name: 'list');

        final expected = ListFieldBlocState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1],
          formBloc: null,
          extraData: null,
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.addFieldBloc(boolean1);
      });
    });

    group('updateExtraData', () {
      test('update', () {
        final list =
            ListFieldBloc<BooleanFieldBloc<Object>, String>(name: 'list');

        final expected = ListFieldBlocState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [],
          formBloc: null,
          extraData: 'This is extra data',
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.updateExtraData('This is extra data');
      });
    });

    group('updateFormBloc & removeFormBloc', () {
      final formBloc = _FakeFormBloc();

      test('Success update and remove formBloc', () {
        final list =
            ListFieldBloc<BooleanFieldBloc<Object>, String>(name: 'list');

        final expectedUpdate =
            ListFieldBlocState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [],
          formBloc: formBloc,
          extraData: null,
        );

        list.updateFormBloc(formBloc);

        expect(list.state, expectedUpdate);

        final expectedRemove = expectedUpdate.copyWith(formBloc: Param(null));

        list.removeFormBloc(formBloc);

        expect(list.state, expectedRemove);
      });

      test('Success update the fieldBlocs with the new FormBloc', () {
        final field = BooleanFieldBloc<Object>(name: 'bool');
        final list = ListFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        final expectedUpdate =
            ListFieldBlocState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
          formBloc: formBloc,
          extraData: null,
        );
        final expectedBoolUpdate = BooleanFieldBlocState<Object>(
          name: 'bool',
          value: false,
          error: null,
          isInitial: true,
          suggestions: null,
          isValidated: false,
          isValidating: false,
          formBloc: formBloc,
        );

        list.updateFormBloc(formBloc);

        expect(list.state, expectedUpdate);
        expect(field.state, expectedBoolUpdate);

        final expectedRemove = expectedUpdate.copyWith(formBloc: Param(null));
        final expectedFieldRemove =
            expectedBoolUpdate.copyWith(formBloc: Param(null));

        list.removeFormBloc(formBloc);

        expect(list.state, expectedRemove);
        expect(field.state, expectedFieldRemove);
      });

      test('Failure to remove formBloc because it is not theirs', () {
        final field = BooleanFieldBloc<Object>(name: 'bool');
        final list = ListFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        final expectedUpdate =
            ListFieldBlocState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
          formBloc: formBloc,
          extraData: null,
        );
        final expectedBoolUpdate = BooleanFieldBlocState<Object>(
          name: 'bool',
          value: false,
          error: null,
          isInitial: true,
          suggestions: null,
          isValidated: false,
          isValidating: false,
          formBloc: formBloc,
        );

        list.updateFormBloc(formBloc);

        expect(list.state, expectedUpdate);
        expect(field.state, expectedBoolUpdate);

        list.removeFormBloc(_FakeFormBloc());

        expect(list.state, expectedUpdate);
        expect(field.state, expectedBoolUpdate);
      });
    });
  });
}

import 'package:formz/formz.dart';

// Define input validation errors
enum AnswerError { empty, format }

// Extend FormzInput and provide the input type and error type.
class AnswerInput extends FormzInput<String, AnswerError> {

  // Call super.pure to represent an unmodified form input.
  const AnswerInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const AnswerInput.dirty( String value ) : super.dirty(value);


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == AnswerError.empty ) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  AnswerError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return AnswerError.empty;

    return null;
  }
}
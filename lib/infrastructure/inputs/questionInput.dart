import 'package:formz/formz.dart';

// Define input validation errors
enum QuestionError { empty, format }

// Extend FormzInput and provide the input type and error type.
class QuestionInput extends FormzInput<String, QuestionError> {

  // Call super.pure to represent an unmodified form input.
  const QuestionInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const QuestionInput.dirty( String value ) : super.dirty(value);


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == QuestionError.empty ) return 'El campo está vacío';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  QuestionError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return QuestionError.empty;

    return null;
  }
}
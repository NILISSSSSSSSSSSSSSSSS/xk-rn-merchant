
interface ValidateOptions {
  field?: string
  required?: boolean
  max?: number
  min?: number
  regex?: RegExp
  custom?: (rule: ValidateRule, formData: object)=>{}
  msg?: string
}

export class ValidateRule {
  field?: string
  required?: boolean
  max?: number
  min?: number
  regex?: RegExp
  custom?: (rule: ValidateRule, formData: object)=>{}
  msg?: string
  constructor(options?: ValidateOptions):void
}

export class ValidateResult extends ValidateRule {
  validate?: boolean;
  constructor(options?: ValidateResult):void
}

export class Validator {
  constructor(rules?: ValidateRule[]): void
  validate(formData?: object): ValidateResult
}
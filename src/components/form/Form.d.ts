import { Component, ReactNode, LegacyRef } from "react";
import { ValidateResult, ValidateRule } from "./helpers/validate-form";

interface FormControlProps {
  field: string,
  formData: object,
  validateResult: ValidateResult,
  value?: any,
  onChange?: (value?: any)=> any
  onFormAction?: (actionName?: string, ...arguments?: any[])=> any
}

export class FormControl extends Component<FormControlProps>{
  /** 内部处理，表单动作 */
  handleFormAction?: (actionName?: string, ...arguments?: any[])=> any
}

interface FormProps {
  onSubmit?: (formData: object) => void,
  formData?: object,
  rules?: ValidateRule[],
  fields?: FormField[],
  validateResult?: ValidateResult,
  onFormAction?: (actionName?: string, ...arguments?: any[])=> any
}

export class Form extends Component<FormProps>{}

interface FormFieldOption {
  title?: string,
  value?: any,
}

interface FormFieldProps {
  /** 缺省提示 */
  placeholder?: string, 
  /** 下拉数据 */
  options?: FormFieldOption[],
  /** 
   * @param actionName 动作名称
   * @param arguments 动作参数
   * @description
   * 表单动作，例如查看大图，显示选择弹框，上传文件等等。
   * 如果组件需要返回值则需要返回。
   * 如果返回值为异步的情况，建议采用callback回调的方式返回给组件使用。
   * */
  onFormAction?: (actionName: string, ...arguments: any[])=> any,
  /** 标题 */
  title?: string, // 标题
}

interface FormField {
  field?: string,
  control?: FormControl,
  props?: object,
}

interface CreatedFormContext {
  formData: object,
  rules?: ValidateRule[],
  fields?: FormField[],
  validateResult?: ValidateResult,
}

interface FormContext {
  field: string,
  value?: any,
  formData: object,
  rules?: ValidateRule[],
  fields?: FormField[],
  validateResult?: ValidateResult,
  data: object,
}

type CreatedFormControlVisibleFunction = (context: FormContext) => boolean
type CreatedFormControlVisible = boolean | CreatedFormControlVisibleFunction;

interface CreatedFormControlProps {
  field: string,
  formData: object,
  data: any,
  rules?: ValidateRule[],
  fields?: FormField[],
  validateResult?: ValidateResult,
  value?: any,
  visible?: CreatedFormControlVisible,
  onChange?: (field: string , value: any)=> any
  onFormAction?: (actionName?: string, ...arguments?: any[])=> any
}


interface CreatedFormProps {
  /** 提交数据 */
  onSubmit?:(formData: object) => any, 
  /** todo: 提交前做相关判断 */
  beforeSubmit?:(context: CreatedFormContext) => boolean,
  formData?: object,
  /** 表单数据更改时，触发事件 */
  onChange?: (formData: object) => any, 
  /** 
   * 当字段值变化时调用，此函数会在onChange之前调用，可以在函数中修改formData的值，或者更改下拉联动数据 
   */
  onValueChange?: (field: string , value: any, formData: object)=> any
  /** 校验规则过后，提示的内容 */
  onError?:(validateResult: ValidateResult) => any, 
  validateResult?: ValidateResult, 
  formRef?: LegacyRef<Form>,
  rules?: ValidateRule[],
  fields?: FormField[],
  /** 
   * 暴露到最外面供表单外部组件使用。
   * 常见场景为表单内部未封装处理组件时，需要外部封装特定动作处理组件的情况 
   **/
  onFormAction?: (actionName?: string, ...arguments?: any[])=> any
}

class CreatedForm extends Component<CreatedFormProps>{}
class CreatedFormControl extends Component<CreatedFormControlProps>{}

/**
 * createFormControl 装饰器，主要暴露Form组件中，fields暴露下来的一些属性和函数。
 * @param defaultProps 组件默认属性
 * @param changeFuncName onChange默认的名称
 * @param valuePropsName value默认的名称
 * @param filterChange filterChange当有数据更改时，过滤出事件中的值
 */
export function createFormControl(defaultProps?: object, changeFuncName?: string, valuePropsName?: string, filterChange?: (val: any)=> any) {
  return (formControl: FormControl) => CreatedFormControl
}

export function createForm(
  fields: FormField[],
  rules: ValidateRule[]
) {
  return (form: Form)=> CreatedForm
}
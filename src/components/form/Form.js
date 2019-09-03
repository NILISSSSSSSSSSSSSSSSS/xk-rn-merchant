import React, { Component, useState } from 'react';
import PACKAGE from '../../../node_modules/react-native/package.json';
import { Validator } from './helpers/validate-form';

export function createFormControl(defaultProps = {}, changeFuncName = 'onChange', valuePropsName = 'value', filterChange = value => value) {
  return OriginFormControl => ({
    field, formData, data, validateResult, value, visible = true, onChange, ...otherProps
  }) => {
    const formProps = {
      ...defaultProps, [valuePropsName]: value, [changeFuncName]: val => onChange(field, filterChange(val)), ...otherProps,
    };
    const formContext = {
      field, formData, data, validateResult, value,
    };
    const _visible = visible instanceof Function ? visible(formContext) : visible;
    return _visible ? <OriginFormControl {...formContext} {...formProps} /> : null;
  };
}

export class FormControl extends Component {}
export class Form extends Component {}

const extUseState = (initState) => {
  let state = initState;
  const setState = (newState) => {
    state = newState;
    // todo 通知刷新页面数据
  };
  return [state, setState];
};

// fix 不显示的字段不做校验
const filterRules = (rules = [], fields = [], formData = {}, validateResult = {})=> {
  const allVisibleFields = fields.filter(({ field, visible, data })=> {
    if (visible instanceof Function) {
      const value = formData[field];
      const formContext = {
        field, formData, data, validateResult, value, rules, fields,
      };
      return visible(formContext);
    }
    return visible !== undefined ? visible : true;
  }).map(item=> item.field);
  return rules.filter(rule=> allVisibleFields.includes(rule.field));
};

export function createForm(fields = [], rules = []) {
  return OriginForm => ({
    onSubmit = (fD) => {}, formData = {}, onChange = (fD) => {}, beforeSubmit = () => false, onFormAction = () => {}, onValueChange = () => {}, validateResult: validateResultProp = null, onError = (valRes) => {}, fields: extFields, rules: extRules, formRef, ...props
  }) => {
    const matchs = /^(\d+).(\d+).(\d+)$/g.exec(PACKAGE.version);
    const canUseHooks = matchs[1] >= 1 || matchs[2] >= 59;
    const [validateResult, setValidateResult] = !canUseHooks ? extUseState(null) : useState(null);
    const mFields = fields.concat(extFields);
    const mRules = rules.concat(extRules);
    let mFormRef = null;

    const formContext = {
      formData,
      validateResult: validateResultProp || validateResult,
      fields: mFields,
      rules: mRules,
    };

    const handleChange = (f, v) => {
      onValueChange(f, v, formData);
      onChange({
        ...formData,
        [f]: v,
      });
    };

    const handleSubmit = () => {
      /** fix 不显示的字段不做校验 */
      const _rules = filterRules(mRules, mFields, formData, validateResult);
      console.log('正式校验的规则列表', _rules);
      const validator = new Validator(_rules);
      const valRes = validator.validate(formData);
      if (valRes.validate) {
        formContext.validateResult = valRes;
        const forceSubmit = beforeSubmit(formContext);
        if (forceSubmit) {return;} // 阻止提交
        onSubmit(formData);
        setValidateResult(null);
      } else {
        onError(valRes);
        setValidateResult(valRes);
      }
    };

    const handleFormAction = (actionName, ...args) => {
      const result = mFormRef.handleFormAction(actionName, ...args);
      if (result !== undefined) {return result;}
      return onFormAction && onFormAction(actionName, ...args);
    };

    const originFormRef = (ref) => {
      mFormRef = ref;
      formRef && formRef(ref);
    };

    return (
      <OriginForm ref={originFormRef} {...props} onFormAction={handleFormAction} onSubmit={handleSubmit} {...formContext}>
        {
          mFields.map(({
            control: CreatedFormControl, field = 'field', props: fieldProps, visible, data,
          }) => (
            <CreatedFormControl
              {...fieldProps}
              {...formContext}
              key={field}
              field={field}
              value={formData[field]}
              visible={visible}
              data={data}
              onChange={handleChange}
              onFormAction={(actionName, ...args) => {
                /** fieldProps 中可能会被接管onFormAction，此处需要提前调用onFormAction */
                const result = fieldProps.onFormAction && fieldProps.onFormAction(actionName, ...args);
                if (result !== undefined) {return result;}
                return handleFormAction(actionName, ...args);
              }}
            />
          ))
        }
      </OriginForm>
    );
  };
}


class RenderChildren extends Component {
  render() {
    return <React.Fragment>{this.props.children}</React.Fragment>;
  }
}

export const CreatedForm = createForm()(RenderChildren);

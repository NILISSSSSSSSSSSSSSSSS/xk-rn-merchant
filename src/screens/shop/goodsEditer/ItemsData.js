export const items=(state={})=>{
  const base = state.requesParams.base;
  const goods=state.currentGoods.goods || {}
  const commonItems = [
    {
      title: '名称',
      type: 'input',
      value: base.goodsName,
      placeholder: '请输入商品名称',
      key: 'goodsName',
      maxLength: 15,
    },
    {
      title: '商品分类',
      type: 'horizontal',
      key:'goodsTypeIdName',
      value: `${state.goodsTypeIdName ? `${state.goodsTypeIdName}/` : ''}${state.goodsClassificationName}`,
    },
    {
      title: '店铺分类',
      type: 'horizontal',
      value: `${state.industryId1Name ? `${state.industryId1Name}/` : state.industryId1Name}${state.industryId2Name}`,
      key:'industryId1Name',
    },
    {
      title: '在架状态',
      type: 'switch',
      value: base.goodsStatus == 'UP' ? true : false,
      key: 'goodsStatus',
    },
  ];
  const serviceItems = [
    ...commonItems,
    {
      title: '是否可加购商品',
      type: 'switch',
      value: base.purchased == 1 ? true : false,
      key: 'purchased',
    },
    {
      title: '退款设置',
      type: 'horizontal',
      value: base.refound1,
      key:'refound',
    },
    {
      title: '是否能免费下单',
      type: 'switch',
      value: base.free == 1 ? true : false,
      key: 'free',
    },
    {
      title: '是否作为订金使用',
      type: 'switch',
      value: base.deposit == 1 ? true : false,
      key: 'deposit',
    },
    {
      title: '是否最后结算时付款',
      type: 'switch',
      value: base.zeroOrder == 1 ? true : false,
      key: 'zeroOrder',
    },
  ];
  const goodsItems = [
    ...commonItems,
    {
      title: '是否最后结算时付款',
      type: 'horizontal',
      value: base.free == 1 ? true : false,
      key: 'free',
      type: 'switch',
    },
  ];
  const zhusuItems = [
    ...commonItems,
    {
      title: '退款设置',
      type: 'horizontal',
      value: base.refound1,
      key:'refound',
    },
  ];
  let topitems = commonItems;
  switch (state.goodsTypeIdName) {
    case '服务类':
      topitems = serviceItems;
      break;
    case '商品类':
      topitems = goodsItems;
      break;
    case '住宿类':
      topitems = zhusuItems;
      break;
  }
  goods.id ?topitems.unshift({
    title: '商品编号',
    rightValueStyle:{flex: 1,textAlign: 'right'},
    value:goods.id,
  }) :null
  const items=[
    topitems,
    [
      {
        title: '规格',
        renderView:'renderScaleView'
      }
    ],
    [
      {
        title: '价格',
        renderView:'renderPriceView'
      }
    ],
    [
      {
        title: '商品介绍',
        style:{ alignItems: 'flex-start' },
        rightView:'renderIntroView'
      },{
        title: '展示图片',
        style:{ alignItems: 'flex-start',flexWrap: 'wrap',},
        rightView:'renderPicView'
      }
    ],
  ]
  return items
}

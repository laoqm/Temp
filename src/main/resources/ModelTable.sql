/*==============================================================*/
/* Table: ACCESSED_CAPABILITY_INFO                              */
/*==============================================================*/
create table ACCESSED_CAPABILITY_INFO
(
   ACCESSED_CAPABILITY_ID numeric(9,0) not null comment '能力使用标识',
   CAPABILITY_ID        numeric(9,0) not null comment '能力标识',
   NODE_ID              numeric(9,0) not null comment '网元标识',
   VALID_DATE           datetime not null comment '能力生效的日期',
   EXPIRED_DATE         datetime not null comment '能力失效的日期',
   primary key (ACCESSED_CAPABILITY_ID)
);

alter table ACCESSED_CAPABILITY_INFO comment '本网元可使用能力的集合';

/*==============================================================*/
/* Table: ACCT                                                  */
/*==============================================================*/
create table USER_ACCT.ACCT
(
   ACCT_ID              numeric(12,0) not null comment '为每个帐户生成的唯一编号，只具有逻辑上的含义，没有物理意义。每个帐户标识生成之后，帐户标识在整个服务提供有效期内保持不变。',
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   ACCT_NAME            varchar(50) not null comment '帐户注册的名称',
   ACCT_TYPE            varchar(3) comment '体现集团帐户、省级帐户，便于数据的分拣',
   ADDRESS_ID           numeric(9,0) not null comment '帐户注册联系地址的唯一标识',
   STATE                varchar(3) comment '帐户的状态。 当前帐户记录的状态',
   STATE_DATE           datetime not null comment '帐户状态变更的时间。',
   primary key (ACCT_ID)
);

alter table USER_ACCT.ACCT comment '客户拥有的用来支付特定的电信产品服务费用的实体。';

/*==============================================================*/
/* Index: I_FKK_CUST_152                                        */
/*==============================================================*/
create index I_FKK_CUST_152 on USER_ACCT.ACCT
(
   CUST_ID
);

/*==============================================================*/
/* Table: ACCT_BALANCE                                          */
/*==============================================================*/
create table USER_ACCT.ACCT_BALANCE
(
   ACCT_BALANCE_ID      numeric(9,0) not null comment '为每个余额帐本生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   BALANCE_TYPE_ID      numeric(9,0) not null comment '余额帐本所属的余额类型',
   PAY_RULE_ID          numeric(9,0),
   ACCT_ID              numeric(12,0) not null comment '为每个帐户生成的唯一编号，只具有逻辑上的含义，没有物理意义。每个帐户标识生成之后，帐户标识在整个服务提供有效期内保持不变。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   BALANCE              numeric(12,0) not null comment '余额帐本余额',
   RESERVE_BALANCE      numeric(12,0) not null comment '预留余额',
   CYCLE_UPPER          numeric(12,0) comment '余额帐本每个帐期可以使用的金额封顶',
   CYCLE_LOWER          numeric(12,0) comment '单个帐期应扣费的最低额。',
   CYCLE_UPPER_TYPE     varchar(3) not null comment '扣费上限类型',
   CYCLE_LOWER_TYPE     varchar(3) not null comment '扣费下限类型',
   STATE                varchar(3) not null comment '余额帐本的状态，包括激活、未激活等。',
   STATE_DATE           datetime not null comment '余额帐本状态变更的时间。',
   primary key (ACCT_BALANCE_ID)
);

alter table USER_ACCT.ACCT_BALANCE comment '对帐户的零头、预付费余额、预存款余额、专项预存费用等的来源、去向、使用记录等进行管理的实体。余额帐本除了表达金额的余额外';

/*==============================================================*/
/* Index: I_FKK_BALANCE_TYPE_83                                 */
/*==============================================================*/
create index I_FKK_BALANCE_TYPE_83 on USER_ACCT.ACCT_BALANCE
(
   BALANCE_TYPE_ID
);

/*==============================================================*/
/* Table: ACCT_BALANCE_LOG                                      */
/*==============================================================*/
create table USER_ACCT.ACCT_BALANCE_LOG
(
   BALANCE_LOG_ID       numeric(12,0) not null comment '余额账本日志标识',
   ACCT_BALANCE_ID      numeric(9,0) not null comment '余额账本标识',
   OPER_INCOME_ID       numeric(12,0) comment '为每个余额流水生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   SRC_AMOUNT           numeric(12,0) not null comment '余额来源原金额',
   OPER_PAYOUT_ID       numeric(12,0) not null comment '支出操作流水',
   PAYOUT_AMOUNT        numeric(12,0) not null comment '支出金额',
   BILLING_CYCLE_ID     numeric(9,0) comment '表明余额对象性质，可选客户/帐户/用户',
   STATE                varchar(3) not null comment '状态',
   STATE_DATE           datetime not null comment '状态时间',
   primary key (BALANCE_LOG_ID)
);

alter table USER_ACCT.ACCT_BALANCE_LOG comment '余额账本日志';

/*==============================================================*/
/* Index: I_FKK_BALANCE_PAYOUT_240                              */
/*==============================================================*/
create index I_FKK_BALANCE_PAYOUT_240 on USER_ACCT.ACCT_BALANCE_LOG
(
   OPER_PAYOUT_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_BALANCE_241                                */
/*==============================================================*/
create index I_FKK_ACCT_BALANCE_241 on USER_ACCT.ACCT_BALANCE_LOG
(
   ACCT_BALANCE_ID
);

/*==============================================================*/
/* Index: I_FKK_BALANCE_SOURCE_242                              */
/*==============================================================*/
create index I_FKK_BALANCE_SOURCE_242 on USER_ACCT.ACCT_BALANCE_LOG
(
   OPER_INCOME_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_245                               */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_245 on USER_ACCT.ACCT_BALANCE_LOG
(
   BILLING_CYCLE_ID
);

/*==============================================================*/
/* Table: ACCT_CREDIT                                           */
/*==============================================================*/
create table USER_ACCT.ACCT_CREDIT
(
   ACCT_ID              numeric(12,0) not null comment '为每个帐户生成的唯一编号，只具有逻辑上的含义，没有物理意义。每个帐户标识生成之后，帐户标识在整个服务提供有效期内保持不变。',
   CREDIT_GRADE         numeric(8,0) comment '帐户的信用等级',
   CREDIT_AMOUNT        numeric(5,0) not null comment '帐户的信用总分',
   EXCEPTION_AMOUNT     numeric(5,0) not null comment '帐户的异常调分',
   EFF_DATE             datetime not null comment '生效时间',
   primary key (ACCT_ID)
);

alter table USER_ACCT.ACCT_CREDIT comment '本实体描述了帐户的在付费方面的信用度情况。';

/*==============================================================*/
/* Index: I_FKK_ACCT_106                                        */
/*==============================================================*/
create index I_FKK_ACCT_106 on USER_ACCT.ACCT_CREDIT
(
   ACCT_ID
);

/*==============================================================*/
/* Table: ACCT_GROUP                                            */
/*==============================================================*/
create table USER_ACCT.ACCT_GROUP
(
   ACCT_GROUP_ID        numeric(9,0) not null comment '帐户群的唯一标识。',
   ACCT_GROUP_DESC      varchar(250) not null comment '对帐户群的详细文字描述。',
   primary key (ACCT_GROUP_ID)
);

alter table USER_ACCT.ACCT_GROUP comment '按照某种需要将特定帐户组合成群组';

/*==============================================================*/
/* Table: ACCT_ITEM                                             */
/*==============================================================*/
create table USER_ACCT.ACCT_ITEM
(
   ACCT_ITEM_ID         numeric(12,0) not null comment '为不同帐目生成的唯一编号。',
   ITEM_SOURCE_ID       numeric(9,0) not null comment '区分同一帐目类型的帐目的不同来源的唯一编号。',
   BILL_ID              numeric(12,0) not null comment '该帐目对应的费用。',
   ACCT_ITEM_TYPE_ID    numeric(9,0) not null comment '电信产品服务费用中的其中一种费用类型。',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '表明余额对象性质，可选客户/帐户/用户',
   ACCT_ID              numeric(12,0) not null comment '为每个帐户生成的唯一编号，只具有逻辑上的含义，没有物理意义。每个帐户标识生成之后，帐户标识在整个服务提供有效期内保持不变。',
   SERV_ID              numeric(12,0) not null comment '为每个产品实例生成的唯一编号。',
   AMOUNT               numeric(12,0) not null comment '要补收补退的金额。',
   CREATED_DATE         datetime not null comment '数据生成日期',
   FEE_CYCLE_ID         numeric(5,0) not null comment '发生费用的帐务周期。指的是用户实际使用电信产品产生的费用当时所在的帐务周期。',
   PAYMENT_METHOD       numeric(9,0) not null comment '为每种付款方式定义的唯一代码',
   STATE                varchar(3) not null comment '帐目的状态。',
   STATE_DATE           datetime not null comment '帐目状态变更的时间。',
   LATN_ID              numeric(9,0) not null comment '帐目所在的本地网，主要用于异地付费',
   primary key (ACCT_ITEM_ID)
);

alter table USER_ACCT.ACCT_ITEM comment '指帐务处理中形成的用户费用数据，用于统计、销帐等处理。';

/*==============================================================*/
/* Index: I_FKK_BILLING_REGION_347                              */
/*==============================================================*/
create index I_FKK_BILLING_REGION_347 on USER_ACCT.ACCT_ITEM
(
   LATN_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_TYPE_61                               */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_TYPE_61 on USER_ACCT.ACCT_ITEM
(
   ACCT_ITEM_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILL_63                                         */
/*==============================================================*/
create index I_FKK_BILL_63 on USER_ACCT.ACCT_ITEM
(
   BILL_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_SOURCE_67                             */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_SOURCE_67 on USER_ACCT.ACCT_ITEM
(
   ITEM_SOURCE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_72                                */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_72 on USER_ACCT.ACCT_ITEM
(
   BILLING_CYCLE_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_154                                        */
/*==============================================================*/
create index I_FKK_ACCT_154 on USER_ACCT.ACCT_ITEM
(
   ACCT_ID
);

/*==============================================================*/
/* Index: I_FKK_SERV_155                                        */
/*==============================================================*/
create index I_FKK_SERV_155 on USER_ACCT.ACCT_ITEM
(
   SERV_ID
);

/*==============================================================*/
/* Index: I_FKK_PAYMENT_METHOD_206                              */
/*==============================================================*/
create index I_FKK_PAYMENT_METHOD_206 on USER_ACCT.ACCT_ITEM
(
   PAYMENT_METHOD
);

/*==============================================================*/
/* Table: ACCT_ITEM_ADJUSTED                                    */
/*==============================================================*/
create table USER_ACCT.ACCT_ITEM_ADJUSTED
(
   ADJUST_RECORD_ID     numeric(9,0) not null comment '调帐帐目记录的唯一标识。',
   ACCT_ITEM_ID         numeric(9,0) not null comment '为不同帐目生成的唯一编号。',
   ADJUST_ACCT_ITEM_ID  numeric(9,0) not null comment '被调帐帐目的标识。',
   CHARGE_ADJUST        numeric(12,0) not null comment '调整的金额',
   primary key (ADJUST_RECORD_ID)
);

alter table USER_ACCT.ACCT_ITEM_ADJUSTED comment '记录调帐产生的帐目数据。';

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_134                                   */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_134 on USER_ACCT.ACCT_ITEM_ADJUSTED
(
   ADJUST_ACCT_ITEM_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_135                                   */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_135 on USER_ACCT.ACCT_ITEM_ADJUSTED
(
   ACCT_ITEM_ID
);

/*==============================================================*/
/* Table: ACCT_ITEM_CLASS                                       */
/*==============================================================*/
create table USER_ACCT.ACCT_ITEM_CLASS
(
   ACCT_ITEM_CLASS_ID   numeric(9,0) not null comment '该帐目类型所属的帐目类型归类的标识。',
   COMMENTS             varchar(250) not null comment '支付规则的中文描述。',
   ACCT_ITEM_CLASS_CODE varchar(15) not null comment '帐目类型归类的标准编码。',
   primary key (ACCT_ITEM_CLASS_ID)
);

alter table USER_ACCT.ACCT_ITEM_CLASS comment '对帐目类型的一个更粗一级的归类，主要便于统计。';

/*==============================================================*/
/* Table: ACCT_ITEM_GROUP                                       */
/*==============================================================*/
create table USER_ACCT.ACCT_ITEM_GROUP
(
   ACCT_ITEM_GROUP_ID   numeric(9,0) not null comment '为每个帐目组生成的唯一编号。',
   ACCT_ITEM_GROUP_NAME varchar(50) not null comment '帐目组的名称。',
   PRIORITY             numeric(3,0) not null comment '定义帐目组之间的优先级关系。',
   STATE                varchar(3) comment '帐目组的状态。',
   STATE_DATE           datetime not null comment '帐目组状态变更的时间。',
   IF_INCLUDE           varchar(1) not null,
   primary key (ACCT_ITEM_GROUP_ID)
);

alter table USER_ACCT.ACCT_ITEM_GROUP comment '客户在指定哪些帐目由哪个帐户支付时的一种帐目分类规则。';

/*==============================================================*/
/* Table: ACCT_ITEM_GROUP_MEMBER                                */
/*==============================================================*/
create table USER_ACCT.ACCT_ITEM_GROUP_MEMBER
(
   ACCT_ITEM_TYPE_ID    numeric(9,0) not null comment '帐目类型的唯一标识。',
   ITEM_SOURCE_ID       numeric(9,0) not null comment '帐目来源的唯一标识。',
   ACCT_ITEM_GROUP_ID   numeric(9,0) not null comment '为每个帐目组生成的唯一编号。',
   STATE                varchar(3) comment '帐目组_帐目的状态。',
   STATE_DATE           datetime not null comment '帐目组_帐目状态变更的时间。',
   primary key (ACCT_ITEM_TYPE_ID, ITEM_SOURCE_ID, ACCT_ITEM_GROUP_ID)
);

alter table USER_ACCT.ACCT_ITEM_GROUP_MEMBER comment '定义每个帐目组包含哪些帐目。';

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_GROUP_58                              */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_GROUP_58 on USER_ACCT.ACCT_ITEM_GROUP_MEMBER
(
   ACCT_ITEM_GROUP_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_TYPE_65                               */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_TYPE_65 on USER_ACCT.ACCT_ITEM_GROUP_MEMBER
(
   ACCT_ITEM_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_SOURCE_66                             */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_SOURCE_66 on USER_ACCT.ACCT_ITEM_GROUP_MEMBER
(
   ITEM_SOURCE_ID
);

/*==============================================================*/
/* Table: ACCT_ITEM_SOURCE                                      */
/*==============================================================*/
create table USER_ACCT.ACCT_ITEM_SOURCE
(
   ITEM_SOURCE_ID       numeric(9,0) not null comment '为每一种帐目类型的帐目的来源生成的唯一标识。',
   ACCT_ITEM_TYPE_ID    numeric(9,0) not null comment '区别帐目类型的唯一标号',
   ITEM_SOURCE_TYPE     varchar(3) not null comment '对帐目来源的一个归类标识。',
   NAME                 varchar(50) not null comment '帐目来源的名称。',
   COMMENTS             varchar(250) not null comment '帐目来源的描述。',
   primary key (ITEM_SOURCE_ID)
);

alter table USER_ACCT.ACCT_ITEM_SOURCE comment '记录帐目的具体来源。';

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_TYPE_70                               */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_TYPE_70 on USER_ACCT.ACCT_ITEM_SOURCE
(
   ACCT_ITEM_TYPE_ID
);

/*==============================================================*/
/* Table: ACCT_ITEM_TYPE                                        */
/*==============================================================*/
create table USER_ACCT.ACCT_ITEM_TYPE
(
   ACCT_ITEM_TYPE_ID    numeric(9,0) not null comment '对每一帐目类型的唯一编号。',
   ACCT_ITEM_CLASS_ID   numeric(9,0) not null comment '该帐目类型所属的帐目类型归类的标识。',
   PARTY_ROLE_ID        numeric(9,0) comment '关联的运营商的唯一标识。',
   NAME                 varchar(50) not null comment '帐目来源的名称。',
   CHARGE_MARK          varchar(3) not null comment '说明是否费用有关的帐目类型。',
   TOTAL_MARK           varchar(3) not null comment '说明是否参与计算总帐目的类型标志。',
   ACCT_ITEM_TYPE_CODE  varchar(15) not null comment '帐目类型的外部标准编码。',
   primary key (ACCT_ITEM_TYPE_ID)
);

alter table USER_ACCT.ACCT_ITEM_TYPE comment '定义帐目的类型。是对计费系统定义的费用的描述，如市话次数费、租费等，而这些帐目有一定的归属关系，如长途基本费和长途附加费';

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_CLASS_64                              */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_CLASS_64 on USER_ACCT.ACCT_ITEM_TYPE
(
   ACCT_ITEM_CLASS_ID
);

/*==============================================================*/
/* Index: I_FKK_EMULATORY_PARTNER_199                           */
/*==============================================================*/
create index I_FKK_EMULATORY_PARTNER_199 on USER_ACCT.ACCT_ITEM_TYPE
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Table: ACCT_RELATIONSHIP                                     */
/*==============================================================*/
create table USER_ACCT.ACCT_RELATIONSHIP
(
   ACCT_ID              numeric(12,0) not null comment '为每个帐户生成的唯一编号，只具有逻辑上的含义，没有物理意义。每个帐户标识生成之后，帐户标识在整个服务提供有效期内保持不变。',
   REL_ACCT_ID          numeric(12,0) not null comment '所关联的帐户标识。',
   ACCT_REL_TYPE        varchar(3) not null comment '帐户关系的类型。',
   primary key (ACCT_ID, REL_ACCT_ID)
);

alter table USER_ACCT.ACCT_RELATIONSHIP comment '表达帐户与帐户之间的关系。';

/*==============================================================*/
/* Index: I_FKK_ACCT_141                                        */
/*==============================================================*/
create index I_FKK_ACCT_141 on USER_ACCT.ACCT_RELATIONSHIP
(
   ACCT_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_142                                        */
/*==============================================================*/
create index I_FKK_ACCT_142 on USER_ACCT.ACCT_RELATIONSHIP
(
   REL_ACCT_ID
);

/*==============================================================*/
/* Table: ACC_NBR_TYPE                                          */
/*==============================================================*/
create table ACC_NBR_TYPE
(
   ACC_NBR_TYPE         varchar(3) not null comment '号码类型，包括物理号码、IMSI等',
   TYPE_DESC            varchar(64) comment '号码类型描述',
   primary key (ACC_NBR_TYPE)
);

alter table ACC_NBR_TYPE comment '定义号码类型取值';

/*==============================================================*/
/* Table: ACTION                                                */
/*==============================================================*/
create table USER_PRODUCT.ACTION
(
   ACTION_ID            numeric(9,0) not null comment '唯一标识一个动作，如：拆机、装机、移机等',
   ACTION_TYPE_ID       numeric(9,0) not null comment '唯一标识一个动作，如：拆机、装机、移机等',
   ACTION_NAME          varchar(50) not null comment '动作名称,
            10A 装机
            10B 移机
            10C 改号
            10D 拆机
            10E 停机
            10F 复机
            10G 改信息
            10H 过户
            10I 合户
            10J 其他
            ',
   primary key (ACTION_ID)
);

alter table USER_PRODUCT.ACTION comment '描述提供服务具体对应的动作，如装拆移改等';

/*==============================================================*/
/* Index: I_FKK_ACTION_TYPE_201                                 */
/*==============================================================*/
create index I_FKK_ACTION_TYPE_201 on USER_PRODUCT.ACTION
(
   ACTION_TYPE_ID
);

/*==============================================================*/
/* Table: ACTION_TYPE                                           */
/*==============================================================*/
create table USER_PRODUCT.ACTION_TYPE
(
   ACTION_TYPE_ID       numeric(9,0) not null comment '唯一标识一个动作，如：拆机、装机、移机等',
   ACTION_TYPE_NAME     varchar(50) not null comment '动作名称',
   primary key (ACTION_TYPE_ID)
);

alter table USER_PRODUCT.ACTION_TYPE comment '对于某种动作，特别是变更动作需要细化，比如电话改ISDN、改银行帐号等等，因此需要引入动作类型对这些动作进行分类.
                                             -';

/*==============================================================*/
/* Table: ADDRESS                                               */
/*==============================================================*/
create table USER_LOCATION.ADDRESS
(
   ADDRESS_ID           numeric(9,0) not null comment '发票上打印的投递地址信息。',
   PROVINCE_NAME        varchar(30) not null comment '省名',
   CITY_NAME            varchar(30) not null comment '城市名',
   STREET_NAME          varchar(30) not null comment '街道的名称。',
   STREET_NBR           varchar(30) not null comment '门牌号',
   DETAIL               varchar(250) not null comment '详细的地址信息。',
   POSTCODE             varchar(30) not null comment '邮政编码',
   primary key (ADDRESS_ID)
);

alter table USER_LOCATION.ADDRESS comment '描述参与人及产品实例的物理地址。';

/*==============================================================*/
/* Table: AGGREGATE_OBJECT                                      */
/*==============================================================*/
create table USER_PRICING.AGGREGATE_OBJECT
(
   BELONG_CALC_OBJECT_ID numeric(9,0) not null comment '所属参考对象的标识',
   SUB_CALC_OBJECT_ID   numeric(9,0) not null comment '用于累加的参考对象的标识',
   CALC_DIRECTION       varchar(3) not null comment '分为正向(为加),反向(为减)',
   primary key (BELONG_CALC_OBJECT_ID, SUB_CALC_OBJECT_ID)
);

alter table USER_PRICING.AGGREGATE_OBJECT comment '是一种特殊类型的定价参考对象，这类对象的值是通过由其他对象的值累加（减）得来的。';

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_25                           */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_25 on USER_PRICING.AGGREGATE_OBJECT
(
   BELONG_CALC_OBJECT_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_26                           */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_26 on USER_PRICING.AGGREGATE_OBJECT
(
   SUB_CALC_OBJECT_ID
);

/*==============================================================*/
/* Table: AGREEMENT                                             */
/*==============================================================*/
create table PARTY_USER.AGREEMENT
(
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   AGREEMENT_TYPE       varchar(3) not null comment '协议类型。',
   SIGN_DATE            datetime not null comment '协议签署时间。',
   COMPLETED_DATE       datetime not null comment '电信公司真正完成施工的日期。',
   ACCEPT_STAFF_ID      numeric(9,0) not null comment '电信公司签署协议的员工的工号。',
   STATE                varchar(3) not null comment '协议完成的状态。',
   COMMENTS             varchar(250) not null comment '客户协议的具体描述。',
   primary key (AGREEMENT_ID)
);

alter table PARTY_USER.AGREEMENT comment '客户与电信运营商签订的具有法律效力的约定，它包含了关于订购、使用电信相关产品，以及与费用支付相关的条款。主要有代销协议、';

/*==============================================================*/
/* Index: I_FKK_CUST_151                                        */
/*==============================================================*/
create index I_FKK_CUST_151 on PARTY_USER.AGREEMENT
(
   CUST_ID
);

/*==============================================================*/
/* Table: AGREEMENT_ATTR                                        */
/*==============================================================*/
create table PARTY_USER.AGREEMENT_ATTR
(
   AGREEMENT_ID         numeric(12,0) not null comment '所属客户协议的唯一标识号。',
   OBJECT_ID            numeric(12,0) not null comment '协议涉及对象实例的唯一标识。',
   ITEM_SEQ_NO          numeric(12,0) not null comment '协议属性的流水编号',
   ATTR_TYPE            varchar(3) not null comment '协议项所属的元素类别。',
   ATTR_ID              numeric(9,0) not null comment '协议项所属的元素的标识。',
   ATTR_VALUE           varchar(250) not null comment '协议项的具体取值。',
   primary key (AGREEMENT_ID, OBJECT_ID, ITEM_SEQ_NO, ATTR_TYPE, ATTR_ID)
);

alter table PARTY_USER.AGREEMENT_ATTR comment '描述了客户协议相关的属性。';

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_OBJECT_224                            */
/*==============================================================*/
create index I_FKK_AGREEMENT_OBJECT_224 on PARTY_USER.AGREEMENT_ATTR
(
   AGREEMENT_ID,
   OBJECT_ID
);

/*==============================================================*/
/* Table: AGREEMENT_OBJECT                                      */
/*==============================================================*/
create table PARTY_USER.AGREEMENT_OBJECT
(
   AGR_AGREEMENT_ID     numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   OBJECT_ID            numeric(12,0) not null comment '协议相关对象的对象实例标识。',
   BELONG_OBJECT_TYPE   varchar(3) not null comment '所属对象的类型。',
   BELONG_OBJECT_ID     numeric(9,0) not null comment '所属对象的唯一标识。',
   PARENT_OBJECT_ID     numeric(12,0) comment '协议相关对象对应的父对象的标识。',
   primary key (AGR_AGREEMENT_ID, OBJECT_ID)
);

alter table PARTY_USER.AGREEMENT_OBJECT comment '描述了客户协议涉及的对象。';

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_222                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_222 on PARTY_USER.AGREEMENT_OBJECT
(
   AGR_AGREEMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_OBJECT_223                            */
/*==============================================================*/
create index I_FKK_AGREEMENT_OBJECT_223 on PARTY_USER.AGREEMENT_OBJECT
(
   AGR_AGREEMENT_ID,
   PARENT_OBJECT_ID
);

/*==============================================================*/
/* Table: APPORTION_RESULT                                      */
/*==============================================================*/
create table USER_ACCT.APPORTION_RESULT
(
   DEPART_RESULT_ID     numeric(9,0) not null comment '摊分结果的唯一标识。',
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '帐务周期',
   DEPART_OBJECT_ID     varchar(3) not null comment '摊分结果的类型。',
   PARD_ID              numeric(9,0) not null comment '合作伙伴的唯一标识。',
   DEPART_BILLING_CYCLE_ID numeric(9,0) not null comment '摊分结果所属的帐务周期',
   DEPART_CHARGE        numeric(12,0) not null comment '摊分后的具体金额。',
   primary key (DEPART_RESULT_ID)
);

alter table USER_ACCT.APPORTION_RESULT comment '定义对分摊对象进行分摊分成以后的结果明细。';

/*==============================================================*/
/* Index: I_FKK_SERV_239                                        */
/*==============================================================*/
create index I_FKK_SERV_239 on USER_ACCT.APPORTION_RESULT
(
   SERV_ID
);

/*==============================================================*/
/* Table: ATOM_TREE2                                            */
/*==============================================================*/
create table USER_STAT.ATOM_TREE2
(
   TREE_ID              numeric(9,0) not null comment '树标识',
   TREE_NAME            varchar(50) not null comment '树名称',
   STRUCT_LEVEL         varchar(30) not null comment '树干级别长度，记录内容必须填满至20位，如23300000000000000000，数字之和小于等于20。上述表示3级，其中第1级长度2位，第2级长度3位，第3级长度3位。',
   DESCRIPTION          varchar(250) not null comment '描述',
   primary key (TREE_ID)
);

alter table USER_STAT.ATOM_TREE2 comment '定义原子树的基本信息';

/*==============================================================*/
/* Table: ATOM_TREE_STRUCT2                                     */
/*==============================================================*/
create table USER_STAT.ATOM_TREE_STRUCT2
(
   TREE_NODE_ID         numeric(9,0) not null comment '原子树节点标识',
   TREE_ID              numeric(9,0) comment '原子树标识',
   NODE_ID              varchar(30) not null comment '节点编码',
   NODE_NAME            varchar(50) not null comment '节点名称',
   NODE_LEVEL           numeric(5,0) not null comment '节点级别',
   SEQ_ID               numeric(9,0) not null comment '序号',
   DESCRIPTION          varchar(250) not null comment '节点描述',
   primary key (TREE_NODE_ID)
);

alter table USER_STAT.ATOM_TREE_STRUCT2 comment '定义原子树的树状结构';

/*==============================================================*/
/* Index: I_FKK_ATOM_TREE_349                                   */
/*==============================================================*/
create index I_FKK_ATOM_TREE_349 on USER_STAT.ATOM_TREE_STRUCT2
(
   TREE_ID
);

/*==============================================================*/
/* Table: ATOM_TREE_STRUCT_ITEM2                                */
/*==============================================================*/
create table USER_STAT.ATOM_TREE_STRUCT_ITEM2
(
   TREE_NODE_ID         numeric(9,0) comment '原子树节点标识',
   NODE_NAME            varchar(50) not null comment '节点名称',
   NODE_LEVEL           numeric(8,0) not null comment '节点级别',
   SEQ_ID               numeric(9,0) not null comment '序号',
   DESCRIPTION          varchar(250) not null comment '节点描述',
   primary key (TREE_NODE_ID)
);

alter table USER_STAT.ATOM_TREE_STRUCT_ITEM2 comment '定义原子树叶子节点与关键ID取值的对应关系';

/*==============================================================*/
/* Index: I_FKK_ATOM_TREE_STRUCT_361                            */
/*==============================================================*/
create index I_FKK_ATOM_TREE_STRUCT_361 on USER_STAT.ATOM_TREE_STRUCT_ITEM2
(
   TREE_NODE_ID
);

/*==============================================================*/
/* Table: ATTR_VALUE_TYPE                                       */
/*==============================================================*/
create table USER_PRODUCT.ATTR_VALUE_TYPE
(
   ATTR_VALUE_TYPE_ID   numeric(9,0) not null comment '属性值类型的唯一标识。',
   ATTR_VALUE_TYPE_NAME varchar(50) not null comment '属性值类型的名称。',
   primary key (ATTR_VALUE_TYPE_ID)
);

alter table USER_PRODUCT.ATTR_VALUE_TYPE comment '属性取值的数据类型，可以为离散数字型，连续数字型，货币型，字符型，日期型，整数等';

/*==============================================================*/
/* Table: ATTR_VALUE_UNIT                                       */
/*==============================================================*/
create table USER_PRODUCT.ATTR_VALUE_UNIT
(
   ATTR_VALUE_UNIT_ID   numeric(9,0) not null comment '属性值单位的唯一标识。',
   ATTR_VALUE_UNIT_NAME varchar(50) not null comment '属性值单位的名称。',
   primary key (ATTR_VALUE_UNIT_ID)
);

alter table USER_PRODUCT.ATTR_VALUE_UNIT comment '属性值单位
如，小时，分钟，秒，Bit，Byte，KByte，MByte';

/*==============================================================*/
/* Table: BALANCE_ACCT_ITEM_PAYED                               */
/*==============================================================*/
create table USER_ACCT.BALANCE_ACCT_ITEM_PAYED
(
   OPER_PAYOUT_ID       numeric(12,0) not null comment '为每个余额流水生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   ACCT_ITEM_ID         numeric(12,0) not null comment '为不同帐目生成的唯一编号。',
   BALANCE              numeric(12,0) not null comment '操作后余额帐本的余额',
   STATE                varchar(3) not null comment '有效/无效',
   STATE_DATE           datetime not null comment '状态发生改变的时间',
   primary key (OPER_PAYOUT_ID, ACCT_ITEM_ID)
);

alter table USER_ACCT.BALANCE_ACCT_ITEM_PAYED comment '如果是扣款销帐，记录扣款时使用余额的详细帐目。';

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_221                                   */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_221 on USER_ACCT.BALANCE_ACCT_ITEM_PAYED
(
   ACCT_ITEM_ID
);

/*==============================================================*/
/* Index: I_FKK_BALANCE_PAYOUT_226                              */
/*==============================================================*/
create index I_FKK_BALANCE_PAYOUT_226 on USER_ACCT.BALANCE_ACCT_ITEM_PAYED
(
   OPER_PAYOUT_ID
);

/*==============================================================*/
/* Table: BALANCE_PAYOUT                                        */
/*==============================================================*/
create table USER_ACCT.BALANCE_PAYOUT
(
   OPER_PAYOUT_ID       numeric(12,0) not null comment '为每个余额流水生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   ACCT_BALANCE_ID      numeric(9,0) not null comment '操作流水所对应的余额帐本标识',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '如果是扣费，扣费对应的帐期，否则记录发生操作的当前帐期',
   BILL_ID              numeric(12,0) comment '如果是扣费销帐，记录操作对应的帐单号',
   OPER_TYPE            varchar(3) not null comment '取/扣/冲等操作',
   STAFF_ID             numeric(9,0) not null comment '操作工号',
   OPER_DATE            datetime not null comment '操作发生的时间',
   AMOUNT               numeric(12,0) not null comment '操作的金额',
   BALANCE              numeric(12,0) not null comment '操作后余额帐本的余额',
   PRN_COUNT            numeric(8,0) comment '该操作被打印的次数',
   BALANCE_RELATION_ID  numeric(9,0) comment '余额对象账本关系',
   STATE                varchar(3) not null comment '有效/无效',
   STATE_DATE           datetime not null comment '状态发生改变的时间',
   primary key (OPER_PAYOUT_ID)
);

alter table USER_ACCT.BALANCE_PAYOUT comment '记录余额帐本的每一次支出操作信息。';

/*==============================================================*/
/* Index: I_FKK_BALANCE_RELATION_247                            */
/*==============================================================*/
create index I_FKK_BALANCE_RELATION_247 on USER_ACCT.BALANCE_PAYOUT
(
   BALANCE_RELATION_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_BALANCE_218                                */
/*==============================================================*/
create index I_FKK_ACCT_BALANCE_218 on USER_ACCT.BALANCE_PAYOUT
(
   ACCT_BALANCE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_219                               */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_219 on USER_ACCT.BALANCE_PAYOUT
(
   BILLING_CYCLE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILL_220                                        */
/*==============================================================*/
create index I_FKK_BILL_220 on USER_ACCT.BALANCE_PAYOUT
(
   BILL_ID
);

/*==============================================================*/
/* Table: BALANCE_PRESENT_RULE                                  */
/*==============================================================*/
create table USER_ACCT.BALANCE_PRESENT_RULE
(
   PRESENT_RULE_ID      numeric(9,0) not null comment '赠送规则的标识',
   PAY_BALANCE_TYPE_ID  numeric(9,0) comment '余额帐本所属的余额类型',
   PRESENT_BALANCE_TYPE_ID numeric(9,0) comment '余额帐本所属的余额类型',
   PRESENT_RULE_DESC    varchar(250) not null comment '规则的具体信息描述',
   REF_CEIL             numeric(12,0) not null comment '预存金额比较的条件上限',
   REF_FLOOR            numeric(12,0) not null comment '预存金额比较的条件下限，当预存金额在上下限之间，表示符合规则条件',
   BASE_VALUE           numeric(12,0) not null comment '计算公式的基础值',
   CALC_METHOD          varchar(1) not null comment '计算公式的计算方法：+-*/',
   CALC_VALUE           numeric(12,0) not null comment '计算方法对应的计算值',
   CALC_RATE            numeric(12,5) not null comment '计算公式中的比例',
   CALC_PRECISION       numeric(5,0) not null comment '最终计算结果的精度',
   MAX_VALUE            numeric(12,0) not null comment '限制一次赠送余额的最大值',
   EFF_OFFSET_UNIT      varchar(3) not null comment '赠送余额开始生效的时间偏移单位：日、月等',
   EFF_OFFSET_VALUE     numeric(9,0) not null comment '赠送余额开始生效的偏移值',
   STATE                varchar(3) not null comment '规则是否生效的状态',
   STATE_DATE           datetime not null comment '状态时间',
   EFF_DATE             datetime not null comment '规则的生效日期',
   EXP_DATE             datetime not null comment '规则的失效日期',
   primary key (PRESENT_RULE_ID)
);

alter table USER_ACCT.BALANCE_PRESENT_RULE comment '定义余额预存的赠送规则

赠送的金额 ＝ BASE_VALUE + (交纳金额 CALC_MET';

/*==============================================================*/
/* Index: I_FKK_BALANCE_TYPE_295                                */
/*==============================================================*/
create index I_FKK_BALANCE_TYPE_295 on USER_ACCT.BALANCE_PRESENT_RULE
(
   PAY_BALANCE_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_BALANCE_TYPE_296                                */
/*==============================================================*/
create index I_FKK_BALANCE_TYPE_296 on USER_ACCT.BALANCE_PRESENT_RULE
(
   PRESENT_BALANCE_TYPE_ID
);

/*==============================================================*/
/* Table: BALANCE_RELATION                                      */
/*==============================================================*/
create table USER_ACCT.BALANCE_RELATION
(
   BALANCE_RELATION_ID  numeric(9,0) not null comment '余额对象关系的唯一标识。',
   ACCT_BALANCE_ID      numeric(9,0) not null comment '标示余额帐本。------------',
   OBJECT_TYPE          varchar(3) not null comment '表明余额对象性质，可选客户/帐户/用户',
   OBJECT_ID            numeric(12,0) not null comment '状态发生改变的时间',
   primary key (BALANCE_RELATION_ID)
);

alter table USER_ACCT.BALANCE_RELATION comment '记录余额对象之间的关系。';

/*==============================================================*/
/* Index: I_FKK_ACCT_BALANCE_84                                 */
/*==============================================================*/
create index I_FKK_ACCT_BALANCE_84 on USER_ACCT.BALANCE_RELATION
(
   ACCT_BALANCE_ID
);

/*==============================================================*/
/* Table: BALANCE_RESERVE_DETAIL                                */
/*==============================================================*/
create table BALANCE_RESERVE_DETAIL
(
   BALANCE_RESERVE_ID   numeric(12,0) not null,
   ACCT_BALANCE_ID      numeric(9,0) comment '为每个余额帐本生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   SERIAL_NUMBER        varchar(15),
   OPER_PAYOUT_ID       numeric(12,0) comment '预留余额时对应的支出流水',
   OPER_INCOME_ID       numeric(12,0) comment '预留余额划到商家帐户，对应的商家余额帐户的充值流水',
   AMOUNT               numeric(12,0) not null,
   STATE                varchar(3) comment '小额支付余额状态
            1、预留
            2、解冻
            3、支出
            ',
   CREATED_DATE         datetime not null,
   STATE_DATE           datetime not null,
   primary key (BALANCE_RESERVE_ID)
);

alter table BALANCE_RESERVE_DETAIL comment '记录账本小额支付余额预留信息，根据余额预留的时间，需定期对处于中间状态的余额预留信息进行跟踪';

/*==============================================================*/
/* Table: BALANCE_SHARE_RULE                                    */
/*==============================================================*/
create table USER_ACCT.BALANCE_SHARE_RULE
(
   SHARE_RULE_ID        numeric(12,0) not null comment '共享规则标识',
   ACCT_BALANCE_ID      numeric(12,0) not null comment '为每个余额帐本生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   SHARE_RULE_TYPE_ID   numeric(9,0) not null comment '0：默认共享规则',
   OBJECT_TYPE          varchar(3) not null comment '余额对象类型',
   OBJECT_ID            numeric(12,0) not null comment '余额对象标识',
   SHARE_RULE_TYPE_PRI  numeric(5,0) not null comment '共享规则优先级',
   UPPER_AMOUNT         numeric(12,0) not null comment '扣费上限金额',
   LOWER_AMOUNT         numeric(12,0) not null comment '扣费下限金额',
   EFF_DATE             datetime comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SHARE_RULE_ID)
);

alter table USER_ACCT.BALANCE_SHARE_RULE comment '余额共享规则';

/*==============================================================*/
/* Index: I_FKK_ACCT_BALANCE_243                                */
/*==============================================================*/
create index I_FKK_ACCT_BALANCE_243 on USER_ACCT.BALANCE_SHARE_RULE
(
   ACCT_BALANCE_ID
);

/*==============================================================*/
/* Index: I_FKK_SHARE_RULE_TYPE_244                             */
/*==============================================================*/
create index I_FKK_SHARE_RULE_TYPE_244 on USER_ACCT.BALANCE_SHARE_RULE
(
   SHARE_RULE_TYPE_ID
);

/*==============================================================*/
/* Table: BALANCE_SOURCE                                        */
/*==============================================================*/
create table USER_ACCT.BALANCE_SOURCE
(
   OPER_INCOME_ID       numeric(12,0) not null comment '为每个余额流水生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   ACCT_BALANCE_ID      numeric(9,0) not null comment '操作流水所对应的余额帐本标识',
   OPER_TYPE            varchar(3) not null comment '存/转/补等操作',
   STAFF_ID             numeric(9,0) not null comment '操作工号',
   OPER_DATE            datetime not null comment '操作发生的时间',
   AMOUNT               numeric(12,0) not null comment '操作的金额',
   CUR_AMOUNT           numeric(12,0) not null comment '剩余金额',
   BALANCE_RELATION_ID  numeric(9,0) comment '余额对象帐本关系',
   BALANCE_SOURCE_ID    numeric(9,0) comment '来源类型标识',
   ALLOW_DRAW           varchar(3) not null comment '允许提取标志',
   INV_OFFER            varchar(3) not null comment '提供发票标志',
   CUR_STATUS           varchar(3) not null comment '当前使用状态',
   CUR_STATUS_DATE      datetime not null comment '当前使用时间',
   STATE                varchar(3) not null comment '已生成；已部分使用；已使用完；',
   STATE_DATE           datetime not null comment '状态发生改变的时间',
   primary key (OPER_INCOME_ID)
);

alter table USER_ACCT.BALANCE_SOURCE comment '记录余额帐本的每一笔收入来源.';

/*==============================================================*/
/* Index: I_FKK_BALANCE_RELATION_246                            */
/*==============================================================*/
create index I_FKK_BALANCE_RELATION_246 on USER_ACCT.BALANCE_SOURCE
(
   BALANCE_RELATION_ID
);

/*==============================================================*/
/* Index: I_FKK_BALANCE_SOURCE_TYPE_248                         */
/*==============================================================*/
create index I_FKK_BALANCE_SOURCE_TYPE_248 on USER_ACCT.BALANCE_SOURCE
(
   BALANCE_SOURCE_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_BALANCE_217                                */
/*==============================================================*/
create index I_FKK_ACCT_BALANCE_217 on USER_ACCT.BALANCE_SOURCE
(
   ACCT_BALANCE_ID
);

/*==============================================================*/
/* Table: BALANCE_SOURCE_TYPE                                   */
/*==============================================================*/
create table USER_ACCT.BALANCE_SOURCE_TYPE
(
   BALANCE_SOURCE_ID    numeric(9,0) not null comment '来源类型标识',
   BALANCE_SOURCE_DESC  varchar(250) not null comment '来源类型描述',
   primary key (BALANCE_SOURCE_ID)
);

alter table USER_ACCT.BALANCE_SOURCE_TYPE comment '余额的来源分类，如：
1 现金
2 合家欢余额
3 预付转后付余额
4 ';

/*==============================================================*/
/* Table: BALANCE_TYPE                                          */
/*==============================================================*/
create table USER_ACCT.BALANCE_TYPE
(
   BALANCE_TYPE_ID      numeric(9,0) not null comment '余额帐本所属的余额类型',
   PRIORITY             numeric(5,0) not null comment '余额类型优先级',
   SPE_PAYMENT_ID       numeric(9,0) comment '为每种专款专用生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   MEASURE_METHOD_ID    numeric(9,0) comment '度量方法的标识',
   BALANCE_TYPE_NAME    varchar(50) not null comment '余额类型的名称。',
   primary key (BALANCE_TYPE_ID)
);

alter table USER_ACCT.BALANCE_TYPE comment '对余额类型进行具体定义，包括本金类型。';



/*==============================================================*/
/* Index: I_FKK_SPECIAL_PAYMENT_DESC_79                         */
/*==============================================================*/
create index I_FKK_SPECIAL_PAYMENT_DESC_79 on USER_ACCT.BALANCE_TYPE
(
   SPE_PAYMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_MEASURE_METHOD_294                              */
/*==============================================================*/
create index I_FKK_MEASURE_METHOD_294 on USER_ACCT.BALANCE_TYPE
(
   MEASURE_METHOD_ID
);

/*==============================================================*/
/* Table: BALANCE_TYPE_PARAM                                    */
/*==============================================================*/
create table USER_PRICING.BALANCE_TYPE_PARAM
(
   BALANCE_TYPE_PARAM_ID numeric(9,0) not null comment '余额类型参数标识',
   BALANCE_TYPE_ID      numeric(9,0) not null comment '余额类型标识',
   PARAM_ATTR_ID        numeric(9,0) comment '参数属性标识',
   PARAM_ATTR_NAME      varchar(50) comment '参数名称',
   PARAM_VALUE          varchar(30) comment '参数默认值',
   primary key (BALANCE_TYPE_PARAM_ID)
);

alter table USER_PRICING.BALANCE_TYPE_PARAM comment '余额类型参数，在逻辑模型把“是否提供发票、是否可以提取”等余额特性通过属性表表达，物理落地方式留给厂家自己根据需要实现,';

/*==============================================================*/
/* Table: BAND                                                  */
/*==============================================================*/
create table USER_PRODUCT.BAND
(
   BAND_ID              numeric(9,0) not null comment '品牌的唯一标识',
   BAN_BAND_ID          numeric(9,0) comment '品牌的唯一标识',
   BAND_TYPE            varchar(3) not null comment '品牌归类类型，如：客户品牌，业务品牌等',
   BAND_NAME            varchar(50) not null comment '品牌的名称',
   BAND_DESC            varchar(250) not null comment '品牌的描述',
   IDEA                 varchar(250) not null comment '品牌体现的理念',
   SLOGAN               varchar(250) not null comment '品牌的口号，如：世界触手可及',
   CREATED_DATE         datetime not null comment '品牌的生效时间',
   primary key (BAND_ID)
);

alter table USER_PRODUCT.BAND comment '销售品的品牌，如互联星空';

/*==============================================================*/
/* Index: I_FKK_BAND_267                                        */
/*==============================================================*/
create index I_FKK_BAND_267 on USER_PRODUCT.BAND
(
   BAN_BAND_ID
);

/*==============================================================*/
/* Table: BANK                                                  */
/*==============================================================*/
create table USER_ACCT.BANK
(
   BANK_ID              numeric(9,0) not null comment '如果是用银行付费方式，则本字段表明了是哪个银行',
   BANK_NAME            varchar(50) not null comment '银行完整名称',
   primary key (BANK_ID)
);

alter table USER_ACCT.BANK comment '定义系统涉及的银行。';

/*==============================================================*/
/* Table: BANK_BRANCH                                           */
/*==============================================================*/
create table USER_ACCT.BANK_BRANCH
(
   BANK_BRANCH_ID       numeric(9,0) not null comment '银行分行的唯一标识。',
   BANK_ID              numeric(9,0) not null comment '如果是用银行付费方式，则本字段表明了是哪个银行',
   BANK_BRANCH_NAME     varchar(50) not null comment '银行开户分行的完整名称',
   BANK_ACCT            varchar(30) not null comment '电信在该分行的托收户账号。',
   BANK_ACCT_NAME       varchar(50) not null comment '电信在该分行的托收户名称。',
   primary key (BANK_BRANCH_ID)
);

alter table USER_ACCT.BANK_BRANCH comment '定义系统涉及的银行分行。';

/*==============================================================*/
/* Index: I_FKK_BANK_140                                        */
/*==============================================================*/
create index I_FKK_BANK_140 on USER_ACCT.BANK_BRANCH
(
   BANK_ID
);

/*==============================================================*/
/* Table: BILL                                                  */
/*==============================================================*/
create table USER_ACCT.BILL
(
   BILL_ID              numeric(12,0) not null comment '改变付款记录状态的日期。',
   PAYMENT_ID           numeric(12,0) not null comment '改变付款记录状态的日期。',
   PAYMENT_METHOD       numeric(9,0) comment '为每种付款方式定义的唯一代码',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '表明余额对象性质，可选客户/帐户/用户',
   PARTY_ROLE_ID        numeric(9,0) comment '员工标识',
   ACCT_ID              numeric(12,0) not null comment '为每个帐户生成的唯一编号，只具有逻辑上的含义，没有物理意义。每个帐户标识生成之后，帐户标识在整个服务提供有效期内保持不变。',
   SERV_ID              numeric(12,0) not null comment '区分产品实例记录的唯一标识。',
   ACC_NBR              varchar(20) not null comment '设备外部编号。',
   BILL_AMOUNT          numeric(12,0) not null comment '该帐目对应的费用。',
   LATE_FEE             numeric(12,0) not null comment '该销帐记录对应的帐目的总滞纳金。',
   DERATE_LATE_FEE      numeric(12,0) not null comment '该销帐记录对应的帐目的总减免滞纳金。',
   BALANCE              numeric(12,0) not null comment '使用的余额。',
   LAST_CHANGE          numeric(12,5) not null comment '该销帐记录对应的帐目使用的总上次零头。',
   CUR_CHANGE           numeric(12,5) not null comment '该销帐记录对应的帐目本次产生的领头。',
   CREATED_DATE         datetime not null comment '数据生成日期',
   PAYMENT_DATE         datetime not null comment '交易的总额。',
   USE_DERATE_BLANCE    numeric(12,0) not null comment '使用的冲减产生的余额。',
   INVOICE_ID           numeric(12,0) not null comment '发票记录的唯一编号。',
   STATE                varchar(3) not null comment '销帐记录的状态。 销帐记录的状态。如：已销帐、已返销等。',
   STATE_DATE           datetime not null comment '销帐记录状态变更的时间。',
   primary key (BILL_ID)
);

alter table USER_ACCT.BILL comment '记录用户缴费后生成的帐务单据的相关信息。';

/*==============================================================*/
/* Index: I_FKK_PAYMENT_62                                      */
/*==============================================================*/
create index I_FKK_PAYMENT_62 on USER_ACCT.BILL
(
   PAYMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_73                                */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_73 on USER_ACCT.BILL
(
   BILLING_CYCLE_ID
);

/*==============================================================*/
/* Index: I_FKK_PAYMENT_METHOD_121                              */
/*==============================================================*/
create index I_FKK_PAYMENT_METHOD_121 on USER_ACCT.BILL
(
   PAYMENT_METHOD
);

/*==============================================================*/
/* Index: I_FKK_STAFF_148                                       */
/*==============================================================*/
create index I_FKK_STAFF_148 on USER_ACCT.BILL
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Index: I_FKK_SERV_149                                        */
/*==============================================================*/
create index I_FKK_SERV_149 on USER_ACCT.BILL
(
   SERV_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_150                                        */
/*==============================================================*/
create index I_FKK_ACCT_150 on USER_ACCT.BILL
(
   ACCT_ID
);

/*==============================================================*/
/* Table: BILLING_CYCLE                                         */
/*==============================================================*/
create table USER_ACCT.BILLING_CYCLE
(
   BILLING_CYCLE_ID     numeric(9,0) not null comment '表明余额对象性质，可选客户/帐户/用户',
   BILLING_CYCLE_TYPE_ID numeric(9,0) not null comment '与BILLING_CYCLE_TYPE表的CYCLE_TYPE_ID属性关联。',
   CYCLE_BEGIN_DATE     datetime not null comment '本帐务周期开始的时间。',
   CYCLE_END_DATE       datetime not null comment '本帐务周期截止的时间。',
   DUE_DATE             datetime not null comment '违约金开始计算的时间。',
   BLOCK_DATE           datetime not null comment '该帐务周期应停机的日期。',
   LAST_BILLING_CYCLE_ID numeric(9,0) comment '上级帐务周期的唯一标识，用于表示层次关系。',
   STATE                varchar(3) not null comment '帐务周期的状态。',
   STATE_DATE           datetime not null comment '帐务周期状态变更的时间。',
   primary key (BILLING_CYCLE_ID)
);

alter table USER_ACCT.BILLING_CYCLE comment '定义具体的帐务周期及相关重要日期，供系统或用户选择以指定帐务周期。';

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_TYPE_115                          */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_TYPE_115 on USER_ACCT.BILLING_CYCLE
(
   BILLING_CYCLE_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_143                               */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_143 on USER_ACCT.BILLING_CYCLE
(
   LAST_BILLING_CYCLE_ID
);

/*==============================================================*/
/* Table: BILLING_CYCLE_TYPE                                    */
/*==============================================================*/
create table USER_ACCT.BILLING_CYCLE_TYPE
(
   BILLING_CYCLE_TYPE_ID numeric(9,0) not null comment '帐务周期类别的标识。',
   BILLING_CYCLE_TYPE_NAME varchar(50) not null comment '帐务周期类型的名称。',
   CYCLE_UNIT           varchar(3) not null comment '帐务周期类型对应的周期单位。',
   UNIT_COUNT           numeric(5,0) not null comment '标准编码',
   CYCLE_DURATION       numeric(5,0) not null comment '根据单位间隔设定的偏移量，即帐务周期从哪个单位开始。',
   CYCLE_DURATION_DAYS  numeric(5,0) not null comment '偏移天数，即帐务周期的开始日期。',
   primary key (BILLING_CYCLE_TYPE_ID)
);

alter table USER_ACCT.BILLING_CYCLE_TYPE comment '帐务周期类型';

/*==============================================================*/
/* Table: BILLING_REGION                                        */
/*==============================================================*/
create table USER_LOCATION.BILLING_REGION
(
   REGION_ID            numeric(9,0) not null comment '区域标识',
   PARENT_REGION_ID     numeric(9,0) comment '上级区域的唯一标识，用于表示层次关系。',
   REGION_LEVEL         varchar(3) not null comment '区域级别，越高级别的表明该区域越大。',
   primary key (REGION_ID)
);

alter table USER_LOCATION.BILLING_REGION comment '计费区域是指根据计费管理需要划分的一种电信管理区域。可以包括本地网、营业区、局向等，可根据需要定义新的类型，在本实体中由';

/*==============================================================*/
/* Index: I_FKK_REGION_335                                      */
/*==============================================================*/
create index I_FKK_REGION_335 on USER_LOCATION.BILLING_REGION
(
   REGION_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_REGION_105                              */
/*==============================================================*/
create index I_FKK_BILLING_REGION_105 on USER_LOCATION.BILLING_REGION
(
   PARENT_REGION_ID
);

/*==============================================================*/
/* Table: BILL_ACCT_ITEM                                        */
/*==============================================================*/
create table USER_ACCT.BILL_ACCT_ITEM
(
   BILL_ITEM_TYPE_ID    numeric(9,0) not null comment '为每个帐单项生成的唯一编号。------------',
   ITEM_SOURCE_ID       numeric(9,0) not null comment '帐目来源的唯一标识。',
   ACCT_ITEM_TYPE_ID    numeric(9,0) not null comment '区分不同类型的帐目的唯一编号。',
   primary key (BILL_ITEM_TYPE_ID, ITEM_SOURCE_ID, ACCT_ITEM_TYPE_ID)
);

alter table USER_ACCT.BILL_ACCT_ITEM comment '帐单项_帐目实体用于描述一个帐单项由哪些帐目组成。';

/*==============================================================*/
/* Index: I_FKK_BILL_ITEM_59                                    */
/*==============================================================*/
create index I_FKK_BILL_ITEM_59 on USER_ACCT.BILL_ACCT_ITEM
(
   BILL_ITEM_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_TYPE_68                               */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_TYPE_68 on USER_ACCT.BILL_ACCT_ITEM
(
   ACCT_ITEM_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_SOURCE_69                             */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_SOURCE_69 on USER_ACCT.BILL_ACCT_ITEM
(
   ITEM_SOURCE_ID
);

/*==============================================================*/
/* Table: BILL_FORMAT                                           */
/*==============================================================*/
create table USER_ACCT.BILL_FORMAT
(
   BILL_FORMAT_ID       numeric(9,0) not null comment '为每种帐单格式生成的唯一编号。------------',
   BILL_REMARK_ID       numeric(9,0) not null comment '为每个帐单项生成的唯一编号。',
   FORMAT_NAME          varchar(50) not null comment '帐单格式的名称。',
   primary key (BILL_FORMAT_ID)
);

alter table USER_ACCT.BILL_FORMAT comment '由电信统一定制或根据客户要求定制的帐单的具体格式。包括广告、备注等。';

/*==============================================================*/
/* Index: I_FKK_BILL_REMARK_123                                 */
/*==============================================================*/
create index I_FKK_BILL_REMARK_123 on USER_ACCT.BILL_FORMAT
(
   BILL_REMARK_ID
);

/*==============================================================*/
/* Table: BILL_FORMAT_CUSTOMIZE                                 */
/*==============================================================*/
create table USER_ACCT.BILL_FORMAT_CUSTOMIZE
(
   BILL_FORMAT_CUSTOMIZE_ID numeric(12,0) not null comment '帐单定制标识',
   ACCT_ID              numeric(12,0) not null comment '为每个帐户生成的唯一编号，只具有逻辑上的含义，没有物理意义。每个帐户标识生成之后，帐户标识在整个服务提供有效期内保持不变。',
   BILL_FORMAT_ID       numeric(9,0) not null comment '为每种帐单格式生成的唯一编号。------------',
   BILL_POST_CYCLE      varchar(3) not null comment '帐目类型来源规则的描述',
   ADDRESS_ID           numeric(9,0) not null comment '帐目类型来源规则的描述',
   BILL_POST_METHOD     varchar(3) not null comment '帐目类型来源规则的描述',
   STATE                varchar(3) not null comment '记录状态',
   STATE_DATE           datetime not null comment '状态时间',
   primary key (BILL_FORMAT_CUSTOMIZE_ID)
);

alter table USER_ACCT.BILL_FORMAT_CUSTOMIZE comment '记录用户的帐单、发票定制信息
';

/*==============================================================*/
/* Index: I_FKK_ADDRESS_289                                     */
/*==============================================================*/
create index I_FKK_ADDRESS_289 on USER_ACCT.BILL_FORMAT_CUSTOMIZE
(
   ADDRESS_ID
);

/*==============================================================*/
/* Index: I_FKK_BILL_FORMAT_292                                 */
/*==============================================================*/
create index I_FKK_BILL_FORMAT_292 on USER_ACCT.BILL_FORMAT_CUSTOMIZE
(
   BILL_FORMAT_ID
);

/*==============================================================*/
/* Table: BILL_FORMAT_ITEM                                      */
/*==============================================================*/
create table USER_ACCT.BILL_FORMAT_ITEM
(
   BILL_ITEM_TYPE_ID    numeric(9,0) not null comment '为每个帐单项生成的唯一编号。',
   BILL_FORMAT_ID       numeric(9,0) not null comment '为每种帐单格式生成的唯一编号。------------',
   PRINT_ORDER          numeric(5,0) not null comment '每个帐单项在帐单/发票上打印的顺序。',
   primary key (BILL_ITEM_TYPE_ID, BILL_FORMAT_ID)
);

alter table USER_ACCT.BILL_FORMAT_ITEM comment '描述一个帐单格式由哪些帐单项组成。';

/*==============================================================*/
/* Index: I_FKK_BILL_ITEM_60                                    */
/*==============================================================*/
create index I_FKK_BILL_ITEM_60 on USER_ACCT.BILL_FORMAT_ITEM
(
   BILL_ITEM_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILL_FORMAT_132                                 */
/*==============================================================*/
create index I_FKK_BILL_FORMAT_132 on USER_ACCT.BILL_FORMAT_ITEM
(
   BILL_FORMAT_ID
);

/*==============================================================*/
/* Table: BILL_FORMAT_SELECTOR                                  */
/*==============================================================*/
create table USER_ACCT.BILL_FORMAT_SELECTOR
(
   BILL_FORMAT_SELECTOR_ID numeric(12,0) not null comment '帐单选择标识',
   BILL_FORMAT_CUSTOMIZE_ID numeric(12,0) not null comment '帐单定制标识',
   BILL_FORMAT_ID       numeric(9,0) not null comment '为每种帐单格式生成的唯一编号。------------',
   primary key (BILL_FORMAT_SELECTOR_ID)
);

alter table USER_ACCT.BILL_FORMAT_SELECTOR comment '定义帐单定制的条件选择，选择的条件类型可以有区域、付费方式、操作类型、主产品实例等。鉴于选择规则实现的不同，此处对条件选';

/*==============================================================*/
/* Index: I_FKK_BILL_FORMAT_CUSTOMI_291                         */
/*==============================================================*/
create index I_FKK_BILL_FORMAT_CUSTOMI_291 on USER_ACCT.BILL_FORMAT_SELECTOR
(
   BILL_FORMAT_CUSTOMIZE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILL_FORMAT_293                                 */
/*==============================================================*/
create index I_FKK_BILL_FORMAT_293 on USER_ACCT.BILL_FORMAT_SELECTOR
(
   BILL_FORMAT_ID
);

/*==============================================================*/
/* Table: BILL_ITEM                                             */
/*==============================================================*/
create table USER_ACCT.BILL_ITEM
(
   BILL_ITEM_TYPE_ID    numeric(9,0) not null comment '为每个帐单项生成的唯一编号。------------',
   CLASSIFY             varchar(3) not null comment '每个帐单项在帐单/发票上打印的顺序。',
   BILL_PARENT_ID       numeric(9,0) comment '上级帐单项的唯一标识，用于表示层次关系。',
   BILL_REMARK_ID       numeric(9,0) not null comment '为每个帐单项生成的唯一编号。',
   PRODUCT_OFFER_ID     numeric(9,0) comment '销售品标识，用于特殊套餐打印指定的帐单项',
   PRINT_ORDER          numeric(5,0) not null comment '每个帐单项在帐单/发票上打印的顺序。',
   primary key (BILL_ITEM_TYPE_ID)
);

alter table USER_ACCT.BILL_ITEM comment '帐目按一定的规则组织起来形成帐单项，体现为帐单上的条目。分非费用帐单项和费用帐单项。帐单项分层次，即帐单项也可以由帐单项';

/*==============================================================*/
/* Index: I_FKK_BILL_ITEM_55                                    */
/*==============================================================*/
create index I_FKK_BILL_ITEM_55 on USER_ACCT.BILL_ITEM
(
   BILL_PARENT_ID
);

/*==============================================================*/
/* Index: I_FKK_BILL_REMARK_125                                 */
/*==============================================================*/
create index I_FKK_BILL_REMARK_125 on USER_ACCT.BILL_ITEM
(
   BILL_REMARK_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_285                               */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_285 on USER_ACCT.BILL_ITEM
(
   PRODUCT_OFFER_ID
);

/*==============================================================*/
/* Table: BILL_RECORD                                           */
/*==============================================================*/
create table USER_ACCT.BILL_RECORD
(
   BILL_RECORD_ID       numeric(9,0) not null comment '帐单记录的唯一标识。',
   BILL_FORMAT_CUSTOMIZE_ID numeric(12,0) comment '帐单定制标识',
   BILL_AMOUNT          numeric(12,0) not null comment '该帐目对应的费用。',
   ACC_NBR              varchar(20) not null comment '设备外部编号。',
   BILL_TYPE            varchar(3) not null comment '帐单的类型。包括：电子、纸质等。',
   NAME                 varchar(50) not null comment '帐目来源的名称。',
   ADDRESS_ID           numeric(9,0) not null comment '帐单记录需要投递的帐户联系地址。',
   POST_DATE            datetime not null comment '帐单投递的时间。',
   primary key (BILL_RECORD_ID)
);

alter table USER_ACCT.BILL_RECORD comment '记录每张帐单的关键信息。包括金额、投递时间等。';

/*==============================================================*/
/* Index: I_FKK_BILL_FORMAT_CUSTOMI_290                         */
/*==============================================================*/
create index I_FKK_BILL_FORMAT_CUSTOMI_290 on USER_ACCT.BILL_RECORD
(
   BILL_FORMAT_CUSTOMIZE_ID
);

/*==============================================================*/
/* Table: BILL_REMARK                                           */
/*==============================================================*/
create table USER_ACCT.BILL_REMARK
(
   BILL_REMARK_ID       numeric(9,0) not null comment '为每个帐单项生成的唯一编号。',
   BILL_VARIABLE_ID     numeric(9,0) not null comment '变量的唯一标识号。',
   PRINT_CONDITION      varchar(3) not null comment '对各种可变情况的简单控制条件，如果条件复杂可以再建一个实体来详细描述。',
   PRINT_FORMAT         varchar(3) not null comment '对可变文本的约定打印格式。',
   CONTENT              varchar(250) not null comment '帐单文本中的文本内容（含变量）。',
   primary key (BILL_REMARK_ID)
);

alter table USER_ACCT.BILL_REMARK comment '描述帐单的可变文本。';

/*==============================================================*/
/* Index: I_FKK_BILL_VARIABLE_124                               */
/*==============================================================*/
create index I_FKK_BILL_VARIABLE_124 on USER_ACCT.BILL_REMARK
(
   BILL_VARIABLE_ID
);

/*==============================================================*/
/* Table: BILL_VARIABLE                                         */
/*==============================================================*/
create table USER_ACCT.BILL_VARIABLE
(
   BILL_VARIABLE_ID     numeric(9,0) not null comment '变量的唯一标识号。',
   BILL_VARIABLE_NAME   varchar(50) not null comment '帐单变量的变量名。',
   primary key (BILL_VARIABLE_ID)
);

alter table USER_ACCT.BILL_VARIABLE comment '描述可变文本中包含的变量。';

/*==============================================================*/
/* Table: BORDER_ROAMING_REGION                                 */
/*==============================================================*/
create table USER_LOCATION.BORDER_ROAMING_REGION
(
   BORDER_ROAMING_ID    numeric(9,0) not null,
   REGION_ID            numeric(9,0) not null,
   CELL_INFO_ID         numeric(9,0) comment '唯一标识电信设备的编号',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (BORDER_ROAMING_ID)
);

alter table USER_LOCATION.BORDER_ROAMING_REGION comment 'CELL信息，用于小区优惠的引用或边界漫游的判断CELL区域';

/*==============================================================*/
/* Table: CAPABILITY_INFO                                       */
/*==============================================================*/
create table CAPABILITY_INFO
(
   CAPABILITY_ID        numeric(9,0) not null comment '能力标识',
   CAPABILITY_CODE      varchar(15) not null comment '用于统一识别业务能力，采用单词缩写，等长4位。',
   CAPABILITY_NAME      varchar(50) not null comment '业务能力名称，作为服务能力提供、激活、去激活和寻址的关键字。
            
            命名规则为：
            <ServiceName>.<CatagoryName>.<DomainName>.ChinaTelecom.com
            
            例如：
            Recharge.VC.ShangHai,chinatelecom.com',
   CAPABILITY_DESC      varchar(250) comment '能力的具体描述',
   STATE                varchar(20) not null comment '能力的状态。包括登记、激活、去激活、注销',
   STATE_DATE           datetime not null comment '当前状态开始的日期',
   primary key (CAPABILITY_ID)
);

alter table CAPABILITY_INFO comment '计费网可以提供的所有能力的全集。计费网能力是计费网各网元提供的业务能力和处理能力的总和。';

/*==============================================================*/
/* Index: idx_nodename                                          */
/*==============================================================*/
create unique index idx_nodename on CAPABILITY_INFO
(
   CAPABILITY_NAME
);

/*==============================================================*/
/* Table: CATALOG                                               */
/*==============================================================*/
create table USER_PRODUCT.CATALOG
(
   CATALOG_ID           numeric(9,0) not null comment '用于唯一标识产品目录的内部编号',
   CATALOG_TYPE         varchar(3) comment '用于标识产品目录的类型,主要是包括了产品和销售品目录',
   CATALOG_NAME         varchar(50) not null comment '用于命名产品目录',
   CATALOG_DESC         varchar(250) not null comment '用于说明注释产品目录',
   primary key (CATALOG_ID)
);

alter table USER_PRODUCT.CATALOG comment '产品目录(Product Catalog)主要是将电信的所有产品和对外的业务提供进行排列，给出一个整体的目录，并且能够从';

/*==============================================================*/
/* Table: CATALOG_ITEM                                          */
/*==============================================================*/
create table USER_PRODUCT.CATALOG_ITEM
(
   CATALOG_ITEM_ID      numeric(9,0) not null comment '产品目录节点的唯一标识。',
   PARENT_CATALOG_ITEM_ID numeric(9,0) comment '上层节点的标识，用于表达目录的层次关系。',
   CATALOG_ID           numeric(9,0) not null comment '用于唯一标识产品目录的内部编号',
   BAND_ID              numeric(9,0) comment '品牌的唯一标识',
   CATALOG_ITEM_TYPE    varchar(3) comment '目录节点的类型。',
   CATALOG_ITEM_NAME    varchar(50) not null comment '产品目录节点的名称。',
   CATALOG_ITEM_DESC    varchar(250) not null comment '用于说明注释元素',
   primary key (CATALOG_ITEM_ID)
);

alter table USER_PRODUCT.CATALOG_ITEM comment '是目录上的一个单位组成元素。每个节点可以包含一个或多个产品、销售品或归类节点。';

/*==============================================================*/
/* Index: I_FKK_BAND_258                                        */
/*==============================================================*/
create index I_FKK_BAND_258 on USER_PRODUCT.CATALOG_ITEM
(
   BAND_ID
);

/*==============================================================*/
/* Index: I_FKK_CATALOG_177                                     */
/*==============================================================*/
create index I_FKK_CATALOG_177 on USER_PRODUCT.CATALOG_ITEM
(
   CATALOG_ID
);

/*==============================================================*/
/* Index: I_FKK_CATALOG_ITEM_178                                */
/*==============================================================*/
create index I_FKK_CATALOG_ITEM_178 on USER_PRODUCT.CATALOG_ITEM
(
   PARENT_CATALOG_ITEM_ID
);

/*==============================================================*/
/* Table: CATALOG_ITEM_ELEMENT                                  */
/*==============================================================*/
create table USER_PRODUCT.CATALOG_ITEM_ELEMENT
(
   CATALOG_ITEM_ID      numeric(9,0) not null comment '所属产品目录节点的唯一标识。',
   ELEMENT_TYPE         varchar(3) not null comment '用于说明元素类型，目录元素的类别，可以为：- 产品- 销售品',
   ELEMENT_ID           numeric(9,0) not null comment '目录中具体元素的ID，如果是产品/服务的目录则为Product_ID，如果是捆绑的目录则为Prod_Bundle_ID，如果是Offer的目录则为Offer_ID',
   EXTERNAL_CODE        varchar(30) comment '目录节点元素的外部编码表示',
   primary key (CATALOG_ITEM_ID, ELEMENT_TYPE, ELEMENT_ID)
);

alter table USER_PRODUCT.CATALOG_ITEM_ELEMENT comment '目录节点所包含的元素。';

/*==============================================================*/
/* Index: I_FKK_CATALOG_ITEM_176                                */
/*==============================================================*/
create index I_FKK_CATALOG_ITEM_176 on USER_PRODUCT.CATALOG_ITEM_ELEMENT
(
   CATALOG_ITEM_ID
);

/*==============================================================*/
/* Table: CC_BUSINESS_TYPE                                      */
/*==============================================================*/
create table CC_BUSINESS_TYPE
(
   CC_BUSINESS_TYPE_ID  numeric(9,0) not null comment '信控处理业务类型的唯一标识。',
   PRODUCT_ID           numeric(9,0) comment '如果该信控业务类型是附属产品级的，该字段表达是哪种附属产品',
   CC_BUSINESS_TYPE_NAME varchar(50) not null comment '信控处理业务类型的名称。',
   STANDARD_CODE        varchar(15) not null comment '信控处理业务类型对应的编码',
   primary key (CC_BUSINESS_TYPE_ID)
);

alter table CC_BUSINESS_TYPE comment '描述信控处理的业务类型，如：余额提醒、催缴、单停、双停、复机、停来显等。';

/*==============================================================*/
/* Table: CC_BUSINESS_TYPE_GROUP                                */
/*==============================================================*/
create table CC_BUSINESS_TYPE_GROUP
(
   CC_TYPE_GROUP_ID     numeric(9,0) not null comment '信控处理业务类型组的唯一标识',
   CC_TYPE_GROUP_NAME   varchar(50) not null,
   primary key (CC_TYPE_GROUP_ID)
);

alter table CC_BUSINESS_TYPE_GROUP comment '信控业务类型组，包含一组信控业务类型。如：复机处理必须依赖单停或双停，那么复机处理的前置业务类型有两个，用一个业务类型组';

/*==============================================================*/
/* Table: CC_OBJECT_EXINFO                                      */
/*==============================================================*/
create table CC_OBJECT_EXINFO
(
   CC_OBJECT_EXINFO_ID  numeric(9,0) not null comment '信控处理补充信息的唯一标识',
   CC_OBJECT_EXINFO_DESC varchar(250) not null comment '信控处理补充信息的描述',
   primary key (CC_OBJECT_EXINFO_ID)
);

alter table CC_OBJECT_EXINFO comment '描述处理对象的补充信息；如信控的处理对象是个商品；但是如果商品下的某成员又订购了其他某些商品，则不进行处理；具体的补充信';

/*==============================================================*/
/* Table: CC_PLAN                                               */
/*==============================================================*/
create table CC_PLAN
(
   CC_PLAN_ID           numeric(9,0) not null,
   CC_PLAN_DESC         varchar(250) not null comment '对信控计划的具体描述，概括信控计划的内容',
   primary key (CC_PLAN_ID)
);

alter table CC_PLAN comment '信控计划实体是信控部分的核心概念之一。当前生产中，信控的需求，举如下两个例子：
信控需求一：
对';

/*==============================================================*/
/* Table: CC_PLAN_INSTANCE_RELATION                             */
/*==============================================================*/
create table CC_PLAN_INSTANCE_RELATION
(
   RELATION_ID          numeric(12,0) not null comment '主键，唯一标识一个关系。',
   CC_PLAN_ID           numeric(9,0) not null comment '对应的信控计划标识',
   INSTANCE_TYPE        varchar(3) not null comment '描述实例的类型，如：用户、账户等。',
   INSTANCE_ID          numeric(12,0) not null comment '具体的实例标识，和实例类型相关联。当实例类型是用户时，这个字段的值为SERV.SERV_ID，当实例类型为账户时，这个字段的值为ACCT.ACCT_ID。',
   PRIORITY             numeric(9,0) not null comment '描述优先级，数值越大，级别越高。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (RELATION_ID)
);

alter table CC_PLAN_INSTANCE_RELATION comment '描述实例级的对象采用的信控计划。如某些用户采用特殊的信控计划，典型的例子是免停免催的用户。';

/*==============================================================*/
/* Table: CC_PLAN_OBJECT                                        */
/*==============================================================*/
create table USER_ACCT.CC_PLAN_OBJECT
(
   RELATION_ID          numeric(9,0) not null,
   CC_PLAN_ID           numeric(9,0) not null,
   BAND_ID              numeric(9,0) comment '描述某种品牌的客户
            ',
   CREDIT_GRADE_ID      numeric(9,0) comment '描述某种信用等级的用户',
   PRODUCT_ID           numeric(9,0) comment '描述某种产品规格的用户',
   OFFER_ID             numeric(9,0) comment '描述某销售品的对象，如E9-2销售品实例',
   REGION_ID            numeric(9,0) comment '描述某个区域',
   BILLING_MODE         varchar(3),
   PRIORITY             numeric(9,0) not null comment '描述该记录的优先级，数字越大，优先级越大。一个用户可能属于多种类型（比如既是E9的成员，也是某种产品），先按照优先级高的计划执行',
   生效时间                 datetime not null,
   失效时间                 datetime,
   primary key (RELATION_ID)
);

alter table USER_ACCT.CC_PLAN_OBJECT comment '如信控计划实体的描述，信控的需求包含对象和一组信控规则，本实体描述某种类型的对象适用某个信控计划，如：小灵通、固定电话适';

/*==============================================================*/
/* Table: CC_STRATEGY                                           */
/*==============================================================*/
create table CC_STRATEGY
(
   CC_STRATEGY_ID       numeric(9,0) not null comment '信控处理策略唯一标识',
   CC_PLAN_ID           numeric(9,0) not null comment '当前信控策略锁属的信控计划标识',
   CC_TYPE_GROUP_ID     numeric(9,0) comment '描述当前策略执行的“前置业务类型”前提，如：双停必须是在单停的基础上执行',
   STATE                varchar(3) comment '描述当前策略执行的用户状态前提，如：用户的状态必须是内拆',
   TIME_PERIOD_ID       numeric(9,0) comment '描述当前策略对应的信控处理业务类型允许执行的时段；如夜间不做催缴。',
   EXEC_EVENT_CODE      varchar(3) not null comment '实时/定时/账期末',
   PRICING_RULE_ID      numeric(9,0) comment '描述当前策略执行的余额、欠费等判断条件，如余额小于10元；单停1个星期以上。',
   CC_TYPE_CODE         varchar(3) not null comment '当前用户/当前销售品/当前对象的捆绑对象/当前对象的代表号码；
            当是当前销售品时，该计划必须对应一个销售品。',
   CC_OBJECT_EXINFO_ID  numeric(9,0) comment '该字段的设计，来源于这样的需求：
            我的E家系列销售品，做销售品级捆绑停机。但是停机时，如果宽带有按年缴费，那么宽带不停。此时，信控处理对象类型为“当前销售品”，本字段作为补充信息，描述不包含按年缴费的宽带。本字段参考“信控对象补充信息表”，对补充信息的描述，建议按需扩展。',
   CC_BUSINESS_TYPE_ID  numeric(9,0) comment '描述当前策略做什么，单停、双停等。',
   primary key (CC_STRATEGY_ID)
);

alter table CC_STRATEGY comment '描述一个信控处理的规则，如：欠费50单停。';

/*==============================================================*/
/* Table: CC_TYPE_GROUP_MEMBER                                  */
/*==============================================================*/
create table CC_TYPE_GROUP_MEMBER
(
   CC_BUSINESS_TYPE_ID  numeric(9,0) comment '信控处理业务类型的唯一标识。',
   CC_TYPE_GROUP_ID     numeric(9,0) comment '信控处理业务类型组的唯一标识'
);

alter table CC_TYPE_GROUP_MEMBER comment '描述一个信控处理业务类型组包含的内容';

/*==============================================================*/
/* Table: CELL_INFO                                             */
/*==============================================================*/
create table USER_LOCATION.CELL_INFO
(
   CELL_INFO_ID         numeric(9,0) not null comment '唯一标识电信设备的编号',
   REGION_ID            numeric(9,0) not null comment '区域标识',
   CELL_INFO_NAME       varchar(50) not null,
   MSC_ID               varchar(15) not null,
   LAC_ID               varchar(15),
   CELL_ID              varchar(15),
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (CELL_INFO_ID)
);

alter table USER_LOCATION.CELL_INFO comment 'CELL信息，用于小区优惠的引用或边界漫游的判断CELL区域';

/*==============================================================*/
/* Table: CHANNEL_SEGMENT                                       */
/*==============================================================*/
create table PARTY_USER.CHANNEL_SEGMENT
(
   CHANNEL_SEGMENT_ID   numeric(9,0) not null comment '渠道分类的唯一标识',
   PARTY_ROLE_ID        numeric(12,0) not null comment '参与人角色标识',
   CHANNEL_SEGMENT_TYPE varchar(3) not null comment '渠道分类标准的文字描述',
   CHANNEL_SEGMENT_NAME varchar(50) not null comment '渠道分类的中文名称',
   CHANNEL_SEGMENT_DETAIL varchar(250) not null comment '渠道分类信息的详细描述',
   primary key (CHANNEL_SEGMENT_ID)
);

alter table PARTY_USER.CHANNEL_SEGMENT comment '定义渠道分类方式。';

/*==============================================================*/
/* Index: I_FKK_PARTNER_111                                     */
/*==============================================================*/
create index I_FKK_PARTNER_111 on PARTY_USER.CHANNEL_SEGMENT
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Table: CHARGE_ADJUST_LOG                                     */
/*==============================================================*/
create table USER_ACCT.CHARGE_ADJUST_LOG
(
   CHARGE_ADJUST_LOG_ID numeric(9,0) not null comment '调帐日志的唯一标识。',
   ACCT_ITEM_ID         numeric(9,0) not null comment '被调帐的帐目的唯一标识。',
   CAUSE                varchar(250) not null comment '调帐的详细原因，以供可回朔查询',
   DATE                 datetime not null comment '调帐的时间',
   STAFF_ID             numeric(9,0) not null comment '调帐的员工的唯一标识。',
   primary key (CHARGE_ADJUST_LOG_ID)
);

alter table USER_ACCT.CHARGE_ADJUST_LOG comment '当由于费用计算错误或者别的原因，需要对用户的费用进行调整，为了保持调帐记录的信息，应该记录调帐日志。';

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_ADJUSTED_87                           */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_ADJUSTED_87 on USER_ACCT.CHARGE_ADJUST_LOG
(
   ACCT_ITEM_ID
);

/*==============================================================*/
/* Index: I_FKK_STAFF_136                                       */
/*==============================================================*/
create index I_FKK_STAFF_136 on USER_ACCT.CHARGE_ADJUST_LOG
(
   STAFF_ID
);

/*==============================================================*/
/* Table: CONTACT_MEDIUM                                        */
/*==============================================================*/
create table PARTY_USER.CONTACT_MEDIUM
(
   CONTACT_MEDIUM_ID    numeric(12,0) not null comment '联系信息的唯一标识。',
   PARTY_ROLE_ID        numeric(9,0) not null comment '参与人角色标识',
   ADDRESS_ID           numeric(12,0) comment '发票上打印的投递地址信息。',
   REGION_ID            numeric(9,0) comment '区域标识',
   primary key (CONTACT_MEDIUM_ID)
);

alter table PARTY_USER.CONTACT_MEDIUM comment '联系信息定义了参与人角色与地域的关系，包括参与人角色的各种联系地址、联系电话、MAIL地址等。';

/*==============================================================*/
/* Index: I_FKK_POLITICAL_REGION_339                            */
/*==============================================================*/
create index I_FKK_POLITICAL_REGION_339 on PARTY_USER.CONTACT_MEDIUM
(
   REGION_ID
);

/*==============================================================*/
/* Index: I_FKK_ADDRESS_104                                     */
/*==============================================================*/
create index I_FKK_ADDRESS_104 on PARTY_USER.CONTACT_MEDIUM
(
   ADDRESS_ID
);

/*==============================================================*/
/* Index: I_FKK_PARTY_ROLE_187                                  */
/*==============================================================*/
create index I_FKK_PARTY_ROLE_187 on PARTY_USER.CONTACT_MEDIUM
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Table: CONTENT_CLASS                                         */
/*==============================================================*/
create table USER_PRODUCT.CONTENT_CLASS
(
   CLASS_ID             numeric(9,0) not null comment '内容分类唯一标识',
   PARENT_CLASS_ID      numeric(9,0) comment '上级内容分类唯一标识，没有则为空。',
   PRODUCT_ID           numeric(9,0) comment '用于唯一标识产品/服务的内部编号',
   CLASS_VALUE          varchar(50) not null comment '内容分类取值',
   CLASS_NAME           varchar(50) comment '内容分类名称',
   primary key (CLASS_ID)
);

alter table USER_PRODUCT.CONTENT_CLASS comment 'SP/CP计费涉及的内容分类描述';

/*==============================================================*/
/* Index: I_FKK_CONTENT_CLASS_255                               */
/*==============================================================*/
create index I_FKK_CONTENT_CLASS_255 on USER_PRODUCT.CONTENT_CLASS
(
   PARENT_CLASS_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_256                                     */
/*==============================================================*/
create index I_FKK_PRODUCT_256 on USER_PRODUCT.CONTENT_CLASS
(
   PRODUCT_ID
);

/*==============================================================*/
/* Table: CREDIT_GRADE                                          */
/*==============================================================*/
create table PARTY_USER.CREDIT_GRADE
(
   CREDIT_GRADE_ID      numeric(9,0) not null comment '信用度等级标识',
   CREDIT_GRADE_NAME    varchar(50) not null comment '信用度等级名称',
   primary key (CREDIT_GRADE_ID)
);

alter table PARTY_USER.CREDIT_GRADE comment '描述信用度级别高低';

/*==============================================================*/
/* Table: CREDIT_GRADE_RULE                                     */
/*==============================================================*/
create table PARTY_USER.CREDIT_GRADE_RULE
(
   CREDIT_GRADE_RULE_ID numeric(9,0) not null comment '信用等级规则标识',
   CREDIT_GRADE_ID      numeric(5,0) not null comment '信用度等级标识',
   CREDIT_FLOOR         numeric(8,0) not null comment '信用度下限',
   CREDIT_CEIL          numeric(8,0) not null comment '信用度上限',
   EFF_DATE             datetime not null comment '本记录的生效时间。',
   EXP_DATE             datetime comment '本记录的失效时间。',
   primary key (CREDIT_GRADE_RULE_ID)
);

alter table PARTY_USER.CREDIT_GRADE_RULE comment '描述信用度分数和等级、信用额度等的关系';

/*==============================================================*/
/* Index: I_FKK_CREDIT_GRADE_276                                */
/*==============================================================*/
create index I_FKK_CREDIT_GRADE_276 on PARTY_USER.CREDIT_GRADE_RULE
(
   CREDIT_GRADE_ID
);

/*==============================================================*/
/* Table: CREDIT_RESULT                                         */
/*==============================================================*/
create table PARTY_USER.CREDIT_RESULT
(
   CREDIT_RESULT_ID     numeric(12,0) not null comment '信用度评估结果标识',
   CREDIT_GRADE_ID      numeric(9,0) comment '信用度等级标识',
   OBJECT_TYPE          varchar(3) not null comment '对象类型',
   OBJECT_ID            numeric(12,0) comment '对象标识',
   CREDIT_AMOUNT        numeric(8,0) not null comment '信用度总分',
   EXCEPTION_AMOUNT     numeric(8,0) not null comment '异常调分',
   EFF_DATE             datetime not null comment '生效时间',
   primary key (CREDIT_RESULT_ID)
);

alter table PARTY_USER.CREDIT_RESULT comment '聚合信用度评估结果明细';

/*==============================================================*/
/* Index: I_FKK_CREDIT_GRADE_275                                */
/*==============================================================*/
create index I_FKK_CREDIT_GRADE_275 on PARTY_USER.CREDIT_RESULT
(
   CREDIT_GRADE_ID
);

/*==============================================================*/
/* Table: CREDIT_RESULT_DETAIL                                  */
/*==============================================================*/
create table PARTY_USER.CREDIT_RESULT_DETAIL
(
   CREDIT_RESULT_DETAIL_ID numeric(12,0) not null comment '信用度评估结果明细标识',
   EVAL_RULE_ID         numeric(9,0) comment '评估规则标识',
   OBJECT_TYPE          varchar(3) not null comment '对象类型',
   OBJECT_ID            numeric(12,0) comment '对象标识',
   ACCT_MONTH           varchar(6) not null comment '帐务月份',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '帐务周期标识',
   primary key (CREDIT_RESULT_DETAIL_ID)
);

alter table PARTY_USER.CREDIT_RESULT_DETAIL comment '描述各种对象信用度评估结果明细值';

/*==============================================================*/
/* Index: I_FKK_EVAL_RULE_278                                   */
/*==============================================================*/
create index I_FKK_EVAL_RULE_278 on PARTY_USER.CREDIT_RESULT_DETAIL
(
   EVAL_RULE_ID
);

/*==============================================================*/
/* Table: CREDIT_VALUE                                          */
/*==============================================================*/
create table PARTY_USER.CREDIT_VALUE
(
   CREDIT_VALUE_ID      numeric(9,0) not null,
   CREDIT_VALUE_RULE_ID numeric(9,0),
   CREDIT_VALUE_TYPE_ID numeric(9,0),
   CREDIT_VALUE         numeric(8,0) not null,
   USED_OBJECT_TYPE     varchar(3) not null comment '表示信用额度可以使用的对象类型',
   USED_OBJECT_ID       numeric(12,0) not null comment '表示信用额度可以使用的对象标识',
   EFF_DATE             datetime not null comment '本记录的生效时间。',
   EXP_DATE             datetime comment '本记录的失效时间。',
   primary key (CREDIT_VALUE_ID)
);

alter table PARTY_USER.CREDIT_VALUE comment '信用额度是用来描述客户、帐户或者用户等实体的费用透支额度信息。信用额度分为初始信用额度、临时信用额度、调整信用额度等';

/*==============================================================*/
/* Table: CREDIT_VALUE_RULE                                     */
/*==============================================================*/
create table PARTY_USER.CREDIT_VALUE_RULE
(
   CREDIT_VALUE_RULE_ID numeric(9,0) not null,
   CREDIT_VALUE_RULE_NAME varchar(50) not null,
   primary key (CREDIT_VALUE_RULE_ID)
);

alter table PARTY_USER.CREDIT_VALUE_RULE comment '信用额度的使用和参考规则，如停复机这块的引用方式';

/*==============================================================*/
/* Table: CREDIT_VALUE_TYPE                                     */
/*==============================================================*/
create table PARTY_USER.CREDIT_VALUE_TYPE
(
   CREDIT_VALUE_TYPE_ID numeric(9,0) not null,
   CREDIT_VALUE_TYPE_NAME varchar(50) not null comment '信用额度类型名称',
   primary key (CREDIT_VALUE_TYPE_ID)
);

alter table PARTY_USER.CREDIT_VALUE_TYPE comment '表示信用额度的类型，如普通的，针对生失效时间使用的';

/*==============================================================*/
/* Table: CUST                                                  */
/*==============================================================*/
create table PARTY_USER.CUST
(
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   PARTY_ROLE_ID        numeric(9,0) comment '参与人角色标识',
   CUST_BAND_ID         numeric(9,0) comment '品牌的唯一标识',
   CUST_NAME            varchar(250) not null comment '客户的名称',
   CUST_TYPE_ID         numeric(9,0) not null comment '客户所属的类型',
   CUST_LEVEL_ID        varchar(3) not null comment '客户所属的级别，集团客户、省级客户、本地网客户',
   CUST_LOCATION        numeric(9,0) not null comment '说明客户的服务归属。',
   IS_VIP               varchar(1) not null comment '本客户是否为重点客户',
   PARENT_ID            numeric(12,0) comment '上级客户的唯一标识，用于表示层次关系。',
   CUST_CODE            varchar(20) not null comment '客户的外部统一编号。',
   STATE                varchar(3) not null comment '客户的状态。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime not null comment '失效时间',
   primary key (CUST_ID)
);

alter table PARTY_USER.CUST comment '指一个已获得或可能获得电信公司（包括第三方合作伙伴）所提供的产品和服务，并具有承担法律责任的能力的个人或者组织。';

/*==============================================================*/
/* Index: I_FKK_PARTY_ROLE_300                                  */
/*==============================================================*/
create index I_FKK_PARTY_ROLE_300 on PARTY_USER.CUST
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Table: CUST_ADD_INFO                                         */
/*==============================================================*/
create table PARTY_USER.CUST_ADD_INFO
(
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   INFO_ID              numeric(9,0) not null comment '信息项目的唯一标识。',
   INFO_VALUE           varchar(250) not null comment '客户附加信息的具体内容。',
   EFF_DATE             datetime not null comment '本记录的生效时间。',
   EXP_DATE             datetime comment '本记录的失效时间。',
   primary key (CUST_ID, AGREEMENT_ID, INFO_ID)
);

alter table PARTY_USER.CUST_ADD_INFO comment '定义了客户的一些相关附加信息，以记录客户的一些个性化的信息。';

/*==============================================================*/
/* Index: I_FKK_CUST_98                                         */
/*==============================================================*/
create index I_FKK_CUST_98 on PARTY_USER.CUST_ADD_INFO
(
   CUST_ID
);

/*==============================================================*/
/* Index: I_FKK_CUST_ADD_INFO_ITEM_169                          */
/*==============================================================*/
create index I_FKK_CUST_ADD_INFO_ITEM_169 on PARTY_USER.CUST_ADD_INFO
(
   INFO_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_173                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_173 on PARTY_USER.CUST_ADD_INFO
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Table: CUST_ADD_INFO_ITEM                                    */
/*==============================================================*/
create table PARTY_USER.CUST_ADD_INFO_ITEM
(
   ASS_INFO_ITEM_ID     numeric(9,0) not null comment '客户附加信息项目的唯一标识。',
   ASS_INFO_ITEM_NAME   varchar(50) not null comment '客户附加信息项目的名称。',
   primary key (ASS_INFO_ITEM_ID)
);

alter table PARTY_USER.CUST_ADD_INFO_ITEM comment '本实体描述了客户的一些附加信息，便于描述客户的一些个性化特征。';

/*==============================================================*/
/* Table: CUST_CONTACT_INFO                                     */
/*==============================================================*/
create table PARTY_USER.CUST_CONTACT_INFO
(
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   CONTACT_NAME         varchar(50) not null comment '客户联系人名称。',
   CONTACT_GENDER       varchar(1) not null comment '客户联系人性别。',
   CONTACT_ADDR         varchar(250) not null comment '客户联系人地址。',
   CONTACT_COMPANY      varchar(250) not null comment '客户联系人的单位。',
   DUTY_DESC            varchar(250) not null comment '客户联系人的职务',
   TELEPHONE            varchar(30) not null comment '客户联系人的联系电话',
   MOBILE               varchar(20) not null comment '客户联系人的移动号码',
   POST_CODE            varchar(6) not null comment '客户联系人的邮编',
   EMAIL_ADDRESS        varchar(50) not null comment '客户联系人的EMAIL',
   FAX                  varchar(30) not null comment '客户联系人的传真',
   COMMENTS             varchar(250) not null comment '客户联系信息的具体描述。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (CUST_ID, AGREEMENT_ID)
);

alter table PARTY_USER.CUST_CONTACT_INFO comment '定义了客户的联系人的信息。';

/*==============================================================*/
/* Index: I_FKK_CUST_99                                         */
/*==============================================================*/
create index I_FKK_CUST_99 on PARTY_USER.CUST_CONTACT_INFO
(
   CUST_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_172                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_172 on PARTY_USER.CUST_CONTACT_INFO
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Table: CUST_CORPORATE_INFO                                   */
/*==============================================================*/
create table PARTY_USER.CUST_CORPORATE_INFO
(
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   INDUSTRY_ID          numeric(9,0) comment '个人客户所属行业',
   COMPANY_SIZE         varchar(3) not null comment '企业客户的公司规模',
   BACKGROUND_NOTES     varchar(250) not null comment '企业客户的经营范围信息',
   EMPLOYEE_EDUACTION   varchar(3) not null comment '企业员工的平均文化程度。',
   CORPORATE_PERSON     varchar(250) not null comment '企业客户的主要负责人信息',
   SUPER_MANAGER        varchar(50) not null comment '企业客户的上级主管',
   EXCUTIVE_INFO        varchar(50) not null comment '企业客户的企业负责人',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (CUST_ID, AGREEMENT_ID)
);

alter table PARTY_USER.CUST_CORPORATE_INFO comment '定义了企业单位性质的客户的一些相关信息。';



/*==============================================================*/
/* Index: I_FKK_CUST_96                                         */
/*==============================================================*/
create index I_FKK_CUST_96 on PARTY_USER.CUST_CORPORATE_INFO
(
   CUST_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_171                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_171 on PARTY_USER.CUST_CORPORATE_INFO
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_INDUSTRY_209                                    */
/*==============================================================*/
create index I_FKK_INDUSTRY_209 on PARTY_USER.CUST_CORPORATE_INFO
(
   INDUSTRY_ID
);

/*==============================================================*/
/* Table: CUST_CREDIT                                           */
/*==============================================================*/
create table PARTY_USER.CUST_CREDIT
(
   ACCT_ID              numeric(12,0) not null comment '为每个帐户生成的唯一编号，只具有逻辑上的含义，没有物理意义。每个帐户标识生成之后，帐户标识在整个服务提供有效期内保持不变。',
   CUST_ID              numeric(12,0) comment '帐户所属的客户唯一标识',
   CREDIT_GRADE         varchar(3) not null comment '帐户的信用等级',
   CREDIT_AMOUNT        numeric(5,0) not null comment '帐户的信用总分',
   EXCEPTION_AMOUNT     numeric(5,0) not null comment '帐户的异常调分',
   EFF_DATE             datetime not null comment '生效时间',
   primary key (ACCT_ID)
);

alter table PARTY_USER.CUST_CREDIT comment '记录了电信客户对电信运营商的忠诚度状况。根据客户的信用度和信用度红黑名单评判规则可以产生客户的红黑名单。';

/*==============================================================*/
/* Index: I_FKK_CUST_179                                        */
/*==============================================================*/
create index I_FKK_CUST_179 on PARTY_USER.CUST_CREDIT
(
   CUST_ID
);

/*==============================================================*/
/* Table: CUST_CREDIT_RECORD                                    */
/*==============================================================*/
create table PARTY_USER.CUST_CREDIT_RECORD
(
   CUST_CREDIT_RECORD_ID numeric(12,0) not null comment '客户信用度评估纪录的唯一标识。',
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   CREDIT_GRADE         numeric(5,0) not null comment '客户的信用度等级',
   CREDIT_MARK          numeric(8,0) not null comment '客户的信用度评分',
   MARK_DATE            datetime not null comment '信用度评估的日期',
   primary key (CUST_CREDIT_RECORD_ID)
);

alter table PARTY_USER.CUST_CREDIT_RECORD comment '本实体记录了电信客户对电信服务费用的支付信用度状况，便于电信运营商能作出正确的优惠或处罚措施。';

/*==============================================================*/
/* Index: I_FKK_CUST_97                                         */
/*==============================================================*/
create index I_FKK_CUST_97 on PARTY_USER.CUST_CREDIT_RECORD
(
   CUST_ID
);

/*==============================================================*/
/* Table: CUST_GROUP                                            */
/*==============================================================*/
create table PARTY_USER.CUST_GROUP
(
   CUST_GROUP_ID        numeric(9,0) not null comment '客户群的唯一标识',
   CUST_GROUP_NAME      varchar(50) not null comment '客户群的中文名称',
   CUST_GROUP_DESC      varchar(250) not null comment '描述客户群划分的详细信息',
   primary key (CUST_GROUP_ID)
);

alter table PARTY_USER.CUST_GROUP comment '把一些客户组合在一起成为一个客户组。为了便于电信运营商对某些没有相互关联的客户实行某些相同的优惠政策，把一些客户组成一些';

/*==============================================================*/
/* Table: CUST_GROUP_MEMBER                                     */
/*==============================================================*/
create table PARTY_USER.CUST_GROUP_MEMBER
(
   CUST_GROUP_ID        numeric(9,0) not null comment '客户群的唯一标识',
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   primary key (CUST_ID, CUST_GROUP_ID)
);

alter table PARTY_USER.CUST_GROUP_MEMBER comment '描述了客户组所拥有的客户列表信息。';

/*==============================================================*/
/* Index: I_FKK_CUST_109                                        */
/*==============================================================*/
create index I_FKK_CUST_109 on PARTY_USER.CUST_GROUP_MEMBER
(
   CUST_ID
);

/*==============================================================*/
/* Index: I_FKK_CUST_GROUP_110                                  */
/*==============================================================*/
create index I_FKK_CUST_GROUP_110 on PARTY_USER.CUST_GROUP_MEMBER
(
   CUST_GROUP_ID
);

/*==============================================================*/
/* Table: CUST_IDENTIFICATION                                   */
/*==============================================================*/
create table PARTY_USER.CUST_IDENTIFICATION
(
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   CERTIFICATE_TYPE     varchar(3) not null comment '客户在现实中用于证明自己身份的证件的类型。',
   CERTIFICATE_NO       varchar(30) not null comment '客户在现实中用于证明自己身份的证件号。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime not null comment '失效时间',
   primary key (CUST_ID, AGREEMENT_ID)
);

alter table PARTY_USER.CUST_IDENTIFICATION comment '定义了客户在现实中用于证明自己身份的信息。';

/*==============================================================*/
/* Index: I_FKK_CUST_100                                        */
/*==============================================================*/
create index I_FKK_CUST_100 on PARTY_USER.CUST_IDENTIFICATION
(
   CUST_ID
);

/*==============================================================*/
/* Table: CUST_INTERACTION                                      */
/*==============================================================*/
create table PARTY_USER.CUST_INTERACTION
(
   CUST_INTERACTION_ID  numeric(12,0) not null comment '客户交互信息的唯一标识。',
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   INTERACTION_TYPE     varchar(3) not null comment '交互类型的唯一标识。',
   CONTACT_METHOD       varchar(3) not null comment '电信运营商与电信客户发生联系的方式',
   HAPPEN_DATE          datetime not null comment '交互事件发生的时间',
   COMMENTS             varchar(250) not null comment '客户交互信息的具体描述。',
   primary key (CUST_INTERACTION_ID)
);

alter table PARTY_USER.CUST_INTERACTION comment '记录了电信运营商与电信客户互相联系时发生的事件的信息。';

/*==============================================================*/
/* Index: I_FKK_CUST_95                                         */
/*==============================================================*/
create index I_FKK_CUST_95 on PARTY_USER.CUST_INTERACTION
(
   CUST_ID
);

/*==============================================================*/
/* Table: CUST_INTERACTION_DETAIL                               */
/*==============================================================*/
create table PARTY_USER.CUST_INTERACTION_DETAIL
(
   CUST_INTERACTION_ID  numeric(12,0) not null comment '客户交互信息的唯一标识。',
   INTERACTION_ITEM_ID  numeric(9,0) not null comment '交互信息项目的唯一标识。',
   INFO_VALUE           varchar(250) not null comment '客户附加信息的内容',
   primary key (CUST_INTERACTION_ID, INTERACTION_ITEM_ID)
);

alter table PARTY_USER.CUST_INTERACTION_DETAIL comment '记录了电信运营商与电信客户交互事件附加的详细信息。';

/*==============================================================*/
/* Index: I_FKK_CUST_INTERACTION_166                            */
/*==============================================================*/
create index I_FKK_CUST_INTERACTION_166 on PARTY_USER.CUST_INTERACTION_DETAIL
(
   CUST_INTERACTION_ID
);

/*==============================================================*/
/* Index: I_FKK_CUST_INTERACTION_IT_167                         */
/*==============================================================*/
create index I_FKK_CUST_INTERACTION_IT_167 on PARTY_USER.CUST_INTERACTION_DETAIL
(
   INTERACTION_ITEM_ID
);

/*==============================================================*/
/* Table: CUST_INTERACTION_ITEM                                 */
/*==============================================================*/
create table PARTY_USER.CUST_INTERACTION_ITEM
(
   INTERACTION_ITEM_ID  numeric(9,0) not null comment '交互信息项目的唯一标识。',
   INTERACTION_ITEM_NAME varchar(50) not null comment '交互信息项目的名称。',
   primary key (INTERACTION_ITEM_ID)
);

alter table PARTY_USER.CUST_INTERACTION_ITEM comment '本实体记录了电信运营商与电信客户交互事件附加的详细信息。';

/*==============================================================*/
/* Table: CUST_LOYALTY_RECORD                                   */
/*==============================================================*/
create table PARTY_USER.CUST_LOYALTY_RECORD
(
   CUST_LOYALTY_RECORD_ID numeric(12,0) not null comment '客户忠诚度评估纪录的唯一标识。',
   CUST_ID              numeric(12,0) not null comment '所属的客户唯一标识',
   CREDIT_GRADE         numeric(5,0) not null comment '客户的忠诚度等级',
   CREDIT_MARK          numeric(8,0) not null comment '客户的忠诚度评分',
   MARK_DATE            datetime not null comment '信用度评估的日期',
   primary key (CUST_LOYALTY_RECORD_ID)
);

alter table PARTY_USER.CUST_LOYALTY_RECORD comment '本实体记录了电信客户对电信服务费用的支付信用度状况，便于电信运营商能作出正确的优惠或处罚措施。';

/*==============================================================*/
/* Index: I_FKK_CUST_168                                        */
/*==============================================================*/
create index I_FKK_CUST_168 on PARTY_USER.CUST_LOYALTY_RECORD
(
   CUST_ID
);

/*==============================================================*/
/* Table: CUST_PERSON_INFO                                      */
/*==============================================================*/
create table PARTY_USER.CUST_PERSON_INFO
(
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   BIRTH_DATE           datetime not null comment '客户的生日',
   MARRY_STATUS         varchar(1) not null comment '个人客户的婚姻状况',
   CUST_GENDER          varchar(1) not null comment '个人客户的性别',
   CUST_RELIGION        varchar(3) not null comment '个人客户的宗教信仰',
   CUST_NATIONALITY     varchar(30) not null comment '个人客户的国籍/民族',
   CUST_EDUCATION_LEVEL varchar(3) not null comment '个人客户的学历',
   CUST_INCOME_LEVEL    numeric(12,0) not null comment '个人客户的收入',
   CUST_OCCUPATION      varchar(3) not null comment '个人客户的职业',
   INDUSTRY_ID          numeric(9,0) not null comment '个人客户所属行业',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (CUST_ID, AGREEMENT_ID)
);

alter table PARTY_USER.CUST_PERSON_INFO comment '定义了个人性质的客户的一些相关信息。';


/*==============================================================*/
/* Index: I_FKK_CUST_101                                        */
/*==============================================================*/
create index I_FKK_CUST_101 on PARTY_USER.CUST_PERSON_INFO
(
   CUST_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_170                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_170 on PARTY_USER.CUST_PERSON_INFO
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_INDUSTRY_208                                    */
/*==============================================================*/
create index I_FKK_INDUSTRY_208 on PARTY_USER.CUST_PERSON_INFO
(
   INDUSTRY_ID
);

/*==============================================================*/
/* Table: CUST_TYPE                                             */
/*==============================================================*/
create table PARTY_USER.CUST_TYPE
(
   CUST_TYPE_ID         numeric(9,0) not null comment '客户类型标识',
   CUST_TYPE_NAME       varchar(250) not null comment '客户类型名称',
   primary key (CUST_TYPE_ID)
);

alter table PARTY_USER.CUST_TYPE comment '描述客户的分类，随着业务的不断发展，客户分类的方式不断变化，为了更好的适应业务发展的需要，增加客户类型实体，方便对客户的';

/*==============================================================*/
/* Index: I_FKK_CUST_102                                        */
/*==============================================================*/
create index I_FKK_CUST_102 on PARTY_USER.CUST_TYPE
(
   CUST_TYPE_ID
);

/*==============================================================*/
/* Table: DATA_FORMAT                                           */
/*==============================================================*/
create table USER_EVENT.DATA_FORMAT
(
   DATA_FORMAT_ID       numeric(9,0) not null comment '唯一标识一个数据格式',
   NAME                 varchar(50) not null comment '唯一标识一个数据格式',
   primary key (DATA_FORMAT_ID)
);

alter table USER_EVENT.DATA_FORMAT comment '定义了各种数据类型的格式。
如对时间类型，可能的格式有“YYYYMMDD"、”YYYYMMDDHH24MIS';

/*==============================================================*/
/* Table: DEST_EVENT_FORMAT                                     */
/*==============================================================*/
create table USER_EVENT.DEST_EVENT_FORMAT
(
   EVENT_FORMAT_ID      numeric(9,0) not null comment '计费帐务事件格式的唯一标识。',
   FORMAT_TYPE          varchar(3) not null comment '格式类型：预处理后事件格式、批价后事件格式',
   EVENT_TYPE_ID        numeric(9,0) not null comment '目标事件类型的唯一标识。',
   NAME                 varchar(50) not null comment '目标事件格式名称',
   STATE                varchar(3) comment '目标事件格式的状态。',
   EFF_DATE             datetime not null comment '目标事件格式的生效时间',
   EXP_DATE             datetime comment '目标事件格式的失效时间',
   primary key (EVENT_FORMAT_ID)
);

alter table USER_EVENT.DEST_EVENT_FORMAT comment '目标事件格式（dest event format）是可预定义和扩展的目标事件的格式信息。目标事件格式由目标事件格式项';

/*==============================================================*/
/* Index: I_FKK_DEST_EVENT_TYPE_312                             */
/*==============================================================*/
create index I_FKK_DEST_EVENT_TYPE_312 on USER_EVENT.DEST_EVENT_FORMAT
(
   EVENT_TYPE_ID
);

/*==============================================================*/
/* Table: DEST_EVENT_FORMAT_ITEM                                */
/*==============================================================*/
create table USER_EVENT.DEST_EVENT_FORMAT_ITEM
(
   EVENT_FORMAT_ID      numeric(9,0) not null comment '目标事件格式的唯一标识。',
   EVENT_ATTR_ID        numeric(9,0) not null comment '目标事件属性的唯一标识。',
   `ORDER`              numeric(5,0) not null comment '标识目标事件属性在计费帐务事件格式中的位置',
   primary key (EVENT_ATTR_ID, EVENT_FORMAT_ID)
);

alter table USER_EVENT.DEST_EVENT_FORMAT_ITEM comment '目标事件格式项中定义了构成目标事件格式项的目标事件属性及其在整个目标事件格式中的次序。';

/*==============================================================*/
/* Index: I_FKK_DEST_EVENT_FORMAT_311                           */
/*==============================================================*/
create index I_FKK_DEST_EVENT_FORMAT_311 on USER_EVENT.DEST_EVENT_FORMAT_ITEM
(
   EVENT_FORMAT_ID
);

/*==============================================================*/
/* Index: I_FKK_EVENT_ATTR_313                                  */
/*==============================================================*/
create index I_FKK_EVENT_ATTR_313 on USER_EVENT.DEST_EVENT_FORMAT_ITEM
(
   EVENT_ATTR_ID
);

/*==============================================================*/
/* Table: DEST_EVENT_TYPE                                       */
/*==============================================================*/
create table USER_EVENT.DEST_EVENT_TYPE
(
   EVENT_TYPE_ID        numeric(9,0) not null comment '目标帐务事件类型的唯一标识。',
   NAME                 varchar(50) not null comment '目标事件类型的名称。',
   SUM_EVENT_TYPE       varchar(3) not null comment '目标帐务事件类型所属的上层类别。',
   EVENT_TYPE_CODE      varchar(15) not null comment '目标事件类型的外部标准编码。',
   STATE                varchar(3) not null comment '目标事件类型的状态。',
   EFF_DATE             datetime not null comment '目标事件类型的生效时间',
   EXP_DATE             datetime comment '目标事件类型的失效时间',
   primary key (EVENT_TYPE_ID)
);

alter table USER_EVENT.DEST_EVENT_TYPE comment '目标事件类型（dest event type）是目标事件的分类信息，如：本地语音计费事件、长途语音计费事件、固网短信计费';

/*==============================================================*/
/* Table: DISCOUNT_CALC_OBJECT                                  */
/*==============================================================*/
create table USER_PRICING.DISCOUNT_CALC_OBJECT
(
   DISCONT_EXPRESS_ID   numeric(9,0) not null comment '归属的优惠计算的标识',
   PRICING_REF_OBJECT_ID numeric(9,0) not null comment '参考对象的标识',
   primary key (DISCONT_EXPRESS_ID, PRICING_REF_OBJECT_ID)
);

alter table USER_PRICING.DISCOUNT_CALC_OBJECT comment '用于定义执行一个优惠计算所需要参考的定价参考对象，这些对象的使用方式由优惠计算方法来决定。';

/*==============================================================*/
/* Index: I_FKK_DISCOUNT_EXPRESS_36                             */
/*==============================================================*/
create index I_FKK_DISCOUNT_EXPRESS_36 on USER_PRICING.DISCOUNT_CALC_OBJECT
(
   DISCONT_EXPRESS_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_37                           */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_37 on USER_PRICING.DISCOUNT_CALC_OBJECT
(
   PRICING_REF_OBJECT_ID
);

/*==============================================================*/
/* Table: DISCOUNT_EXPRESS                                      */
/*==============================================================*/
create table USER_PRICING.DISCOUNT_EXPRESS
(
   DISCOUNT_EXPRESS_ID  numeric(9,0) not null comment '优惠计算的标识',
   DISCOUNT_METHOD_ID   numeric(9,0) not null comment '用于定义进行该预算的具体计算方法的标识，如直接计算、打折、封顶保底、赠送固定值、取最大值、取最小值等。其中取最大值、取最小值时，参考对象必须为一个以上，各参考对象的积量类型必须一致，最后的结果为各对象的最大值或者最小值。',
   RATABLE_RESOURCE_ID  numeric(9,0) comment '用于说明该优惠将对哪种积量类型产生影响，主要用于赠送固定值',
   INTEGRAL_TYPE_ID     numeric(9,0) comment '积分类型标识',
   START_REF_VALUE_ID   numeric(9,0) comment '用于说明该优惠计算的最小值，主要用于封顶保底计算',
   END_REF_VALUE_ID     numeric(9,0) comment '用于说明该优惠计算的最大值，主要用于封顶保底计算',
   PRICING_SECTION_ID   numeric(9,0) not null comment '归属的定价段落',
   DISCOUNT_RATE_VALUE_ID numeric(12,5) not null comment '指定折扣率的取值，主要用于折扣计算时确定具体的折扣率',
   FIXED_VALUE_ID       numeric(12,5) not null comment '赠送的固定额取值，主要用于赠送计算时确定具体赠送的数额',
   CALC_PRIORITY        numeric(3,0) not null comment '用于指明在同一个段落下，优惠计算的优先级。优先级数额小的，将得到优先的执行',
   primary key (DISCOUNT_EXPRESS_ID)
);

alter table USER_PRICING.DISCOUNT_EXPRESS comment '构成定价过程中费用调整方案的具体实现方法，每个定价过程可包含一个或多个优惠计算。优惠计算方式包括折扣、赠送、减免、封顶保';

/*==============================================================*/
/* Index: I_FKK_DISCOUNT_METHOD_27                              */
/*==============================================================*/
create index I_FKK_DISCOUNT_METHOD_27 on USER_PRICING.DISCOUNT_EXPRESS
(
   DISCOUNT_METHOD_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_SECTION_49                              */
/*==============================================================*/
create index I_FKK_PRICING_SECTION_49 on USER_PRICING.DISCOUNT_EXPRESS
(
   PRICING_SECTION_ID
);

/*==============================================================*/
/* Index: I_FKK_RATABLE_RESOURCE_50                             */
/*==============================================================*/
create index I_FKK_RATABLE_RESOURCE_50 on USER_PRICING.DISCOUNT_EXPRESS
(
   RATABLE_RESOURCE_ID
);

/*==============================================================*/
/* Index: I_FKK_REF_VALUE_230                                   */
/*==============================================================*/
create index I_FKK_REF_VALUE_230 on USER_PRICING.DISCOUNT_EXPRESS
(
   END_REF_VALUE_ID
);

/*==============================================================*/
/* Index: I_FKK_REF_VALUE_231                                   */
/*==============================================================*/
create index I_FKK_REF_VALUE_231 on USER_PRICING.DISCOUNT_EXPRESS
(
   START_REF_VALUE_ID
);

/*==============================================================*/
/* Table: DISCOUNT_METHOD                                       */
/*==============================================================*/
create table USER_PRICING.DISCOUNT_METHOD
(
   DISCOUNT_METHOD_ID   numeric(9,0) not null comment '优惠计算方法的标识',
   DISCOUNT_METHOD_NAME varchar(50) not null comment '具体的计算方法描述',
   primary key (DISCOUNT_METHOD_ID)
);

alter table USER_PRICING.DISCOUNT_METHOD comment '用于定义模型支持的进行优惠调整的计算方法。优惠计算方法是模型提供的二次开发的重要入口，可以进行扩展，但建议扩展必须在集团';

/*==============================================================*/
/* Table: DISCOUNT_REPATITION_TYPE                              */
/*==============================================================*/
create table USER_PRICING.DISCOUNT_REPATITION_TYPE
(
   REPATITION_TYPE_ID   numeric(9,0) not null comment '优惠摊分方式的标识',
   REPATITION_TYPE_NAME varchar(50) not null comment '摊分类型名称，如均分、按金额均分等',
   PRICING_REF_OBJECT_ID numeric(9,0) comment '参考对象的标识',
   primary key (REPATITION_TYPE_ID)
);

alter table USER_PRICING.DISCOUNT_REPATITION_TYPE comment '将优惠结果值摊分给多个优惠应用对象。建议的摊分方法只支持：均分、按费用总额摊分、按总时长摊分等，不建议支持太多的摊分方式';

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_227                          */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_227 on USER_PRICING.DISCOUNT_REPATITION_TYPE
(
   PRICING_REF_OBJECT_ID
);

/*==============================================================*/
/* Table: DISCOUNT_TARGET_OBJECT                                */
/*==============================================================*/
create table USER_PRICING.DISCOUNT_TARGET_OBJECT
(
   DISCOUNT_EXPRESS_ID  numeric(9,0) not null comment '优惠计算的标识',
   PRICING_REF_OBJECT_ID numeric(9,0) not null comment '参考对象的标识',
   REPATITION_TYPE_ID   numeric(9,0) comment '当有多个应用对象时，说明用哪个摊分规则进行摊分',
   primary key (DISCOUNT_EXPRESS_ID, PRICING_REF_OBJECT_ID)
);

alter table USER_PRICING.DISCOUNT_TARGET_OBJECT comment '定义优惠处理结果的应用目标，它可以是费用项、客户等对象。建议的摊分方法只支持：均分、按费用总额摊分、按总时长摊分等，不建';

/*==============================================================*/
/* Index: I_FKK_DISCOUNT_EXPRESS_46                             */
/*==============================================================*/
create index I_FKK_DISCOUNT_EXPRESS_46 on USER_PRICING.DISCOUNT_TARGET_OBJECT
(
   DISCOUNT_EXPRESS_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_47                           */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_47 on USER_PRICING.DISCOUNT_TARGET_OBJECT
(
   PRICING_REF_OBJECT_ID
);

/*==============================================================*/
/* Index: I_FKK_DISCOUNT_REPATITION_T_48                        */
/*==============================================================*/
create index I_FKK_DISCOUNT_REPATITION_T_48 on USER_PRICING.DISCOUNT_TARGET_OBJECT
(
   REPATITION_TYPE_ID
);

/*==============================================================*/
/* Table: DISCOUNT_TIME_LIMIT                                   */
/*==============================================================*/
create table USER_PRICING.DISCOUNT_TIME_LIMIT
(
   DISCOUNT_TIME_LIMIT_ID numeric(9,0) not null comment '优惠计算时间限制的标识',
   DISCOUNT_EXPRESS_ID  numeric(9,0) not null comment '归属的优惠计算记录标识，说明本限制对那个优惠计算有效',
   DISCOUNT_CYCLE_TYPE  varchar(3) not null comment '说明该优惠根据何种周期类型确定其生效或失效条件',
   BEGIN_TIME_TYPE      varchar(3) not null comment '该优惠开始生效的时间类别，只后面指定的日期是绝对生效日期还是相对生效日期。如可以指定一个具体日期作为绝对生效日期或指定在购买后多少天生效这样的相对生效日期。',
   BEGIN_CALC_OBJECT    numeric(9,0) comment '用于计算生效时间的定价参考对象，可以引用这个定价参考对象的来确定生效日期',
   BEGIN_TIME_DURATION  numeric(12,5) comment '开始生效时间的偏移量，用于指定相对生效日期时使用',
   END_TIME_TYPE        varchar(3) not null comment '该优惠失效的时间类别，只后面指定的日期是绝对失效日期还是相对失效日期。如可以指定一个具体日期作为绝对失效日期或指定在购买后多少天失效这样的相对失效日期。',
   END_CALC_OBJECT      numeric(9,0) comment '用于计算失效时间的定价参考对象，可以引用这个定价参考对象的来确定失效日期',
   END_TIME_DURATION    numeric(12,5) comment '失效时间的偏移量，用于指定相对失效日期时使用',
   primary key (DISCOUNT_TIME_LIMIT_ID)
);

alter table USER_PRICING.DISCOUNT_TIME_LIMIT comment '用于定义优惠执行较复杂的时间方面的限制，如按照某个属性计算生效日期、在多少个帐期内有效等。';

/*==============================================================*/
/* Index: I_FKK_DISCOUNT_EXPRESS_28                             */
/*==============================================================*/
create index I_FKK_DISCOUNT_EXPRESS_28 on USER_PRICING.DISCOUNT_TIME_LIMIT
(
   DISCOUNT_EXPRESS_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_29                           */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_29 on USER_PRICING.DISCOUNT_TIME_LIMIT
(
   BEGIN_CALC_OBJECT
);

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_30                           */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_30 on USER_PRICING.DISCOUNT_TIME_LIMIT
(
   END_CALC_OBJECT
);

/*==============================================================*/
/* Table: EMULATORY_PARTNER                                     */
/*==============================================================*/
create table PARTY_USER.EMULATORY_PARTNER
(
   PARTY_ROLE_ID        numeric(9,0) not null comment '运营商的唯一标识。',
   PARTNER_ID           varchar(30) not null comment '运营商编号',
   PARTNER_TYPE         varchar(3) not null comment '对等运营商类型：分为国内对等运营商、国际对等运营商。',
   PARTNER_DESC         varchar(250) not null comment '描述运营商的基本情况，包括竞争的业务等。',
   primary key (PARTY_ROLE_ID)
);

alter table PARTY_USER.EMULATORY_PARTNER comment '对等运营商是指在电信业务活动中与中国电信主要存在竞争关系的其他运营商。包括中国网通、中国移动、中国联通、中国铁通等。
                                                 ';

/*==============================================================*/
/* Index: I_FKK_PARTY_ROLE_185                                  */
/*==============================================================*/
create index I_FKK_PARTY_ROLE_185 on PARTY_USER.EMULATORY_PARTNER
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Table: EQUIP                                                 */
/*==============================================================*/
create table USER_LOCATION.EQUIP
(
   EQUIP_ID             numeric(9,0) not null comment '唯一标识电信设备的编号',
   EQUIP_NAME           varchar(50) not null comment '电信设备名称，如基站，交换机',
   EQUIP_DESC           varchar(250) not null comment '电信设备的描述',
   EQUIP_TYPE_ID        numeric(9,0) not null comment '唯一标识电信设备类型的编号',
   primary key (EQUIP_ID)
);

alter table USER_LOCATION.EQUIP comment '指构成该设备覆盖的交换机、基站等';

/*==============================================================*/
/* Index: I_FKK_EQUIP_TYPE_329                                  */
/*==============================================================*/
create index I_FKK_EQUIP_TYPE_329 on USER_LOCATION.EQUIP
(
   EQUIP_TYPE_ID
);

/*==============================================================*/
/* Table: EQUIP_REGION                                          */
/*==============================================================*/
create table USER_LOCATION.EQUIP_REGION
(
   REGION_ID            numeric(9,0) not null comment '唯一标识标准地域的编号',
   EQUIP_ID             numeric(9,0) comment '唯一标识电信设备的编号',
   primary key (REGION_ID)
);

alter table USER_LOCATION.EQUIP_REGION comment '设备覆盖区域是指根据设备管理需要划分的一种电信管理区域。可以包括构成设备覆盖区域的交换机、基站等。';

/*==============================================================*/
/* Index: I_FKK_EQUIP_328                                       */
/*==============================================================*/
create index I_FKK_EQUIP_328 on USER_LOCATION.EQUIP_REGION
(
   EQUIP_ID
);

/*==============================================================*/
/* Index: I_FKK_REGION_337                                      */
/*==============================================================*/
create index I_FKK_REGION_337 on USER_LOCATION.EQUIP_REGION
(
   REGION_ID
);

/*==============================================================*/
/* Table: EQUIP_TYPE                                            */
/*==============================================================*/
create table USER_LOCATION.EQUIP_TYPE
(
   EQUIP_TYPE_ID        numeric(9,0) not null comment '唯一标识电信设备类型的编号',
   EQUIP_TYPE_NAME      varchar(50) not null comment '电信设备类型的名称',
   EQUIP_TYPE_DESC      varchar(250) not null comment '电信设备类型的描述',
   primary key (EQUIP_TYPE_ID)
);

alter table USER_LOCATION.EQUIP_TYPE comment '按不同专业网的设备种类进行分类';

/*==============================================================*/
/* Table: EVAL_ADJUST_LOG                                       */
/*==============================================================*/
create table PARTY_USER.EVAL_ADJUST_LOG
(
   EVAL_ADJUST_LOG_ID   numeric(12,0) not null comment '评估调分日志标识',
   EVAL_TYPE            varchar(3) not null comment '评估类型',
   OBJECT_TYPE          varchar(3) not null comment '对象类型',
   OBJECT_ID            numeric(12,0) comment '对象标识',
   EXCEPTION_AMOUNT     numeric(8,0) comment '异常调分',
   ADJUST_DESC          varchar(250) comment '调分描述',
   OPER_STAFF_ID        numeric(9,0) not null comment '操作工号',
   OPER_DATE            datetime not null comment '操作日期',
   primary key (EVAL_ADJUST_LOG_ID)
);

alter table PARTY_USER.EVAL_ADJUST_LOG comment '描述信用度和积分调整信息';

/*==============================================================*/
/* Table: EVAL_INDEX                                            */
/*==============================================================*/
create table PARTY_USER.EVAL_INDEX
(
   TARGET_ID            numeric(9,0) not null comment '指标标识。指计算信用/积分的指定的指标标识值',
   TARGET_TYPE          varchar(3) not null comment '指标类型。10为信用度指标，20为积分指标',
   TARGET_NAME          varchar(50) not null comment '指标名称',
   PERCENTAGE           numeric(12,5) not null comment '信用度和积分指标的比率。',
   COMMENTS             varchar(250) not null comment '信用度和积分子表的附加说明。',
   primary key (TARGET_ID)
);

alter table PARTY_USER.EVAL_INDEX comment '定义客户评估的各种评估指标以及每个指标所占的比重。';

/*==============================================================*/
/* Table: EVAL_PLAN                                             */
/*==============================================================*/
create table PARTY_USER.EVAL_PLAN
(
   EVAL_PLAN_ID         numeric(9,0) not null comment '评估计划标识',
   EVAL_PLAN_NAME       varchar(50) not null comment '评估计划名称',
   EVAL_TYPE            varchar(3) not null comment '评估类型',
   EVAL_OBJECT_TYPE     varchar(3) not null comment '评估对象类型',
   EVAL_DESC            varchar(250) comment '评估计划描述',
   primary key (EVAL_PLAN_ID)
);

alter table PARTY_USER.EVAL_PLAN comment '评估计划描述：是一个或者多个评估规则的集合';

/*==============================================================*/
/* Table: EVAL_RULE                                             */
/*==============================================================*/
create table PARTY_USER.EVAL_RULE
(
   EVAL_RULE_ID         numeric(9,0) not null comment '评估规则标识',
   EVAL_RULE_NAME       varchar(50) not null comment '评估规则名称',
   TARGET_ID            numeric(9,0) not null comment '指标标识。指计算信用/积分的指定的指标标识值',
   EVAL_PLAN_ID         numeric(9,0) comment '评估计划标识',
   FACTOR_CATG_ID       numeric(12,0) not null comment '因素所关联的对象群组，如客户群、帐户群等。',
   DEFAULT_VALUE        numeric(8,0) not null comment '缺省值',
   PERCENTAGE           numeric(12,5) not null comment '信用度和积分因素的比率。',
   COMMENTS             varchar(250) not null comment '信用度和积分因素的附加说明。',
   primary key (EVAL_RULE_ID)
);

alter table PARTY_USER.EVAL_RULE comment '定义影响信用度和积分评估指标的各种因素及各类因素的比重。';

/*==============================================================*/
/* Index: I_FKK_EVAL_PLAN_274                                   */
/*==============================================================*/
create index I_FKK_EVAL_PLAN_274 on PARTY_USER.EVAL_RULE
(
   EVAL_PLAN_ID
);

/*==============================================================*/
/* Index: I_FKK_EVAL_INDEX_280                                  */
/*==============================================================*/
create index I_FKK_EVAL_INDEX_280 on PARTY_USER.EVAL_RULE
(
   TARGET_ID
);

/*==============================================================*/
/* Table: EVENT_ATTR                                            */
/*==============================================================*/
create table USER_EVENT.EVENT_ATTR
(
   EVENT_ATTR_ID        numeric(9,0) not null comment '属性的唯一标识。',
   EVENT_ATTR_TYPE      varchar(3) not null comment '0－源事件 1－计费帐务事件',
   DATA_TYPE            varchar(3) not null comment '事件属性的类型',
   LENGTH               numeric(8,0) not null comment '属性的数据长度',
   `PRECISION`            numeric(5,0) not null comment '事件属性的精度。',
   CH_NAME              varchar(50) not null comment '事件属性的中文名称',
   EN_NAME              varchar(50) not null comment '事件属性的英文名称',
   primary key (EVENT_ATTR_ID)
);

alter table USER_EVENT.EVENT_ATTR comment '事件属性（ratable event attribute）定义了构成事件的最小单元，如主叫号码、被叫号码、通话起始时间、';

/*==============================================================*/
/* Table: EVENT_CONTENT                                         */
/*==============================================================*/
create table USER_EVENT.EVENT_CONTENT
(
   EVENT_CONTENT_ID     numeric(12,0) not null comment '事件内容位置的唯一标识，由该位置标识找出事件内容具体位置',
   EVENT_ATTR_ID        numeric(9,0) not null comment '唯一标识一个事件属性。',
   VALUE                varchar(30) not null comment '对应事件属性的取值。',
   primary key (EVENT_CONTENT_ID, EVENT_ATTR_ID)
);

alter table USER_EVENT.EVENT_CONTENT comment '定义了源事件、目标事件的内容。对目标事件，实际存放时，可参考目标事件的格式对事件内容以横表方式或其它方式存放。';

/*==============================================================*/
/* Index: I_FKK_EVENT_CONTENT_INDEX_302                         */
/*==============================================================*/
create index I_FKK_EVENT_CONTENT_INDEX_302 on USER_EVENT.EVENT_CONTENT
(
   EVENT_CONTENT_ID
);

/*==============================================================*/
/* Index: I_FKK_EVENT_ATTR_303                                  */
/*==============================================================*/
create index I_FKK_EVENT_ATTR_303 on USER_EVENT.EVENT_CONTENT
(
   EVENT_ATTR_ID
);

/*==============================================================*/
/* Table: EVENT_CONTENT_INDEX                                   */
/*==============================================================*/
create table USER_EVENT.EVENT_CONTENT_INDEX
(
   EVENT_CONTENT_ID     numeric(12,0) not null comment '事件内容位置的唯一标识，由该位置标识找出事件内容具体位置',
   primary key (EVENT_CONTENT_ID)
);

alter table USER_EVENT.EVENT_CONTENT_INDEX comment '事件内容的具体位置。';

/*==============================================================*/
/* Table: EVENT_PRICING_STRATEGY                                */
/*==============================================================*/
create table USER_PRICING.EVENT_PRICING_STRATEGY
(
   EVENT_PRICING_STRATEGY_ID numeric(9,0) not null comment '事件定价策略的标识',
   EVENT_TYPE_ID        numeric(9,0) comment '计费帐务事件类型的唯一标识。',
   EVENT_PRICING_STRATEGY_NAME varchar(50) not null comment '事件定价策略名称，用于标识',
   EVENT_PRICING_STRATEGY_DESC varchar(4000) not null comment '详细描述事件定价策略，使用户可以更好地复用事件定价策略',
   primary key (EVENT_PRICING_STRATEGY_ID)
);

alter table USER_PRICING.EVENT_PRICING_STRATEGY comment '事件定价策略就是定义针对一个特定计费帐务事件进行费用计算的方法，对资费和优惠的描述和表达均适用。';

/*==============================================================*/
/* Index: I_FKK_DEST_EVENT_TYPE_321                             */
/*==============================================================*/
create index I_FKK_DEST_EVENT_TYPE_321 on USER_PRICING.EVENT_PRICING_STRATEGY
(
   EVENT_TYPE_ID
);

/*==============================================================*/
/* Table: EXTERNAL_PRODUCT                                      */
/*==============================================================*/
create table USER_PRODUCT.EXTERNAL_PRODUCT
(
   EXTERNAL_PRODUC_ID   numeric(9,0) not null comment '用于唯一标识外部产品的内部编号',
   PRODUCT_PROVIDER_ID  numeric(9,0) not null comment '外部产品的提供者',
   PRODUCT_NAME         varchar(50) not null comment '外部产品名称',
   PRODUCT_COMMENTS     varchar(250) not null comment '外部产品的详细描述',
   STATE                varchar(3) comment '外部产品的状态。 标识一个外部产品当前的状态，包括：a) 作废状态b) 等待批准状态c) 已批准状态 d) 在用状态 e) 失效状态',
   EFF_DATE             datetime not null comment '外部产品生效的日期',
   EXP_DATE             datetime comment '外部产品失效的日期，如果有界定的话。 缺省是空白， 表示没有设计好失效日期',
   primary key (EXTERNAL_PRODUC_ID)
);

alter table USER_PRODUCT.EXTERNAL_PRODUCT comment '外部产品主要记录了具有竞争关系的其外运营商所提供的产品/服务的情报信息；主要用来进行市场分析。';

/*==============================================================*/
/* Index: I_FKK_PARTY_ROLE_203                                  */
/*==============================================================*/
create index I_FKK_PARTY_ROLE_203 on USER_PRODUCT.EXTERNAL_PRODUCT
(
   PRODUCT_PROVIDER_ID
);

/*==============================================================*/
/* Table: EXTERNAL_STATS2                                       */
/*==============================================================*/
create table USER_STAT.EXTERNAL_STATS2
(
   EXTERNAL_TREE_NODE_ID numeric(9,0) comment '外部树节点标识',
   EXTERNAL_TREE_ID     numeric(9,0) not null comment '外部树的目录编码',
   EXTERNAL_NODE_LEVEL  numeric(5,0) not null comment '目录层次级别',
   EXTERNAL_NODE_ID     varchar(30) comment '节点编码',
   EXTERNAL_NODE_NAME   varchar(50) not null comment '节点名称',
   SOURCE_FLAG          numeric(5,0) not null comment '节点数据来源，参考外部树结构中说明',
   TARGET_UNIT          varchar(30) not null comment '指标单位，如元、次数、分钟、户等',
   TARGET_SEQ_ID        numeric(9,0) not null comment '指标序号',
   TARGET_VALUE         numeric(12,0) comment '指标度量值',
   ACCT_MONTH           varchar(6) not null comment '月份',
   primary key (EXTERNAL_TREE_NODE_ID)
);

alter table USER_STAT.EXTERNAL_STATS2 comment '存放外部树的统计数据，根据外部树与对应内部树的引用关系从Internal_Stats中计算获得，其他部分游离指标数据通过';

/*==============================================================*/
/* Index: I_FKK_EXTERNAL_TREE_STRUCT_360                        */
/*==============================================================*/
create index I_FKK_EXTERNAL_TREE_STRUCT_360 on USER_STAT.EXTERNAL_STATS2
(
   EXTERNAL_TREE_NODE_ID
);

/*==============================================================*/
/* Table: EXTERNAL_TREE_STRUCT2                                 */
/*==============================================================*/
create table USER_STAT.EXTERNAL_TREE_STRUCT2
(
   EXTERNAL_TREE_NODE_ID numeric(9,0) not null comment '外部树节点标识',
   EXTERNAL_TREE_ID     numeric(9,0) not null comment '外部树标识',
   EXTERNAL_NODE_LEVEL  numeric(5,0) not null comment '节点层次级别，即位于目录中的第几级',
   EXTERNAL_NODE_ID     varchar(30) comment '节点编码',
   EXTERNAL_NODE_NAME   varchar(50) not null comment '节点名称',
   SOURCE_FLAG          numeric(5,0) not null comment '节点数据来源标识
            1：直接计算：引用对应内部树的节点数据，大部分外部树的非叶子节点直接引用内部树的非叶子节点，而不需要采用内部指标计算。
            2：内部计算：采用本指标内部节点计算；
            3.：游离节点：来自外部的游离节计算值，游离节点的数据单独一个程序（配置语法）来取值
            ',
   WHICH_VALUE          numeric(5,0) not null comment '内部树指标对应度量值，
            1…5分别对应内部树统计数据的Target_Value1…Target_Value5。
            在生成内部树时一次性将不同的度量生成到内部树统计数据的不同字段中，避免重复生成，这样外部树节点数据可以直接选择不同的度量
            ',
   SUM_FLAG             numeric(5,0) not null comment '节点计算标识
            Sum_flag=1：直接计算，约束条件：Source_flag in (1)
            说明：数据来源于内部树的节点数据，Sum_Relation中填写内部树的节点计算表达式；
            Sum_flag=2：层级计算，约束条件：Source_Flag In (2)
            说明：本层数据下的子节点的数据的直接相加之和计算得到本节点数据，这种方式不需要填写Sum_Relation中的表达式；
            Sum_flag=3：错层计算，约束条件：Source_Flag in (2)
            说明：本层数据通过Node_Ralation关系表达式计算得到本节点数据，Node_Ralation公式内节点是本指标的其他节点（可能不是本层之子层数据节点）
            ',
   INTERNAL_TREE_ID     numeric(9,0) not null comment '内部树的目录标识',
   SUM_RELATION         varchar(30) not null comment '节点计算关系式：本指标内的节点的计算表达式，
            比如：@101010@+@101020@，运算符支持＋，－，×，÷和括号
            ',
   FACT_TABLE           varchar(30) not null comment '填写数据来源的顶层中间层表，顶层中间层从Fact_Table_Define中选择',
   TARGET_CODE          varchar(30) not null comment '指标代码',
   TARGET_UNIT          varchar(30) not null comment '指标单位，如元、次数、分钟、户等',
   TARGET_SEQ_ID        numeric(9,0) not null comment '指标序号',
   primary key (EXTERNAL_TREE_NODE_ID)
);

alter table USER_STAT.EXTERNAL_TREE_STRUCT2 comment '外部树的树状结构定义';

/*==============================================================*/
/* Index: I_FKK_TARGET_TREE_355                                 */
/*==============================================================*/
create index I_FKK_TARGET_TREE_355 on USER_STAT.EXTERNAL_TREE_STRUCT2
(
   EXTERNAL_TREE_ID
);

/*==============================================================*/
/* Table: FACT_TABLE_COLUMN2                                    */
/*==============================================================*/
create table USER_STAT.FACT_TABLE_COLUMN2
(
   FACT_TABLE_ID        numeric(9,0) comment '顶层中间层标识',
   FACT_COLUMN          varchar(30) not null comment '顶层中间层字段名',
   FACT_COLUMN_NAME     varchar(50) not null comment '顶层中间层字段名称',
   SOURCE_TABLE         varchar(30) not null comment '来源于中间层的表',
   SOURCE_COLUMN        varchar(30) not null comment '来源于中间层的哪个字段',
   RELATION_COLUMN      varchar(30) not null comment '当顶层中间层的字段不是关键id字段，而是用于更新原子树节点的字段时，该字段是用于填写更新原子树节点参考的字段',
   STA_TREE_TYPE_ID     numeric(9,0) not null comment '需要更新原子树节点信息的原子树目录标识',
   NODE_LEVEL           numeric(5,0) not null comment '需要更新原子树的目录级别',
   DEFULT_NODE_ID       varchar(30) comment '当关联字段值没有在原子树中找到对应节点时，需要再此定义默认节点',
   SEQ_ID               numeric(5,0) not null comment '序列',
   primary key (FACT_TABLE_ID)
);

alter table USER_STAT.FACT_TABLE_COLUMN2 comment '定义顶层中间层相关字段信息';

/*==============================================================*/
/* Index: I_FKK_FACT_TABLE_DEFINE_352                           */
/*==============================================================*/
create index I_FKK_FACT_TABLE_DEFINE_352 on USER_STAT.FACT_TABLE_COLUMN2
(
   FACT_TABLE_ID
);

/*==============================================================*/
/* Table: FACT_TABLE_DEFINE2                                    */
/*==============================================================*/
create table USER_STAT.FACT_TABLE_DEFINE2
(
   FACT_TABLE_ID        numeric(9,0) not null comment '顶层中间层标识',
   FACT_TABLE_NAME      varchar(30) not null comment '顶层中间层表名',
   FACT_TABLE_DESC      varchar(50) not null comment '顶层中间层表中文名称',
   SOURCE_TABLE         varchar(30) not null comment '来源表名',
   GENERATE_TYPE        numeric(5,0) not null comment '顶层中间层数据生成方式
            1 为调用程序生成
            2 为执行语法生成',
   PROC_NAME            varchar(50) not null comment '程序名称',
   SQL_SYNTAX           varchar(4000) not null comment '生成语法',
   SEQ_ID               numeric(5,0) not null comment '顶层中间层生成顺序',
   COMMENTS             varchar(250) not null comment '备注',
   primary key (FACT_TABLE_ID)
);

alter table USER_STAT.FACT_TABLE_DEFINE2 comment '定义顶层中间层表';

/*==============================================================*/
/* Table: GROUP_INSTANCE                                        */
/*==============================================================*/
create table USER_PRODUCT.GROUP_INSTANCE
(
   GROUP_ID             numeric(12,0) not null comment '群组实例',
   GROUP_DESC           varchar(250) comment '群组实例描述信息',
   PRODUCT_ID           numeric(9,0) not null comment '产品标识,表明是那个群组产品的实例化',
   CALC_PRIORITY        numeric(3,0) not null comment '计算的优先级，在一个用户加入多个群中时候',
   primary key (GROUP_ID)
);

alter table USER_PRODUCT.GROUP_INSTANCE comment '群组实例';



/*==============================================================*/
/* Table: GROUP_INSTANCE_MEMBER                                 */
/*==============================================================*/
create table USER_PRODUCT.GROUP_INSTANCE_MEMBER
(
   MEMBER_ID            numeric(9,0) not null comment '唯一标识群组成员的编号',
   MEMBER_DESC          varchar(250) not null comment '群组实例成员的详细描述',
   MEMBER_TYPE_ID       numeric(9,0) not null comment '唯一标识群组成员类型的编号',
   MEMBER_ROLE_ID       numeric(9,0) not null comment '群组实例成员在具体的业务类型中的角色，如VPN中的主号、从号，百千号群的起始号、结束号',
   SERV_ID              numeric(12,0) comment '主产品实例的唯一标识。',
   GROUP_ID             numeric(12,0) not null comment '群组实例唯一标识',
   LIFE_CYCLE_ID        numeric(9,0) not null comment '生命周期的标识',
   MEMBER_OBJECT_ID     numeric(12,0) not null comment '群组成员对象的编号，如号码等',
   ACC_NBR              varchar(20) comment '群组成员接入号码',
   primary key (MEMBER_ID)
);

alter table USER_PRODUCT.GROUP_INSTANCE_MEMBER comment '描述了群组中包含的成员，类型由群组成员类型定义';

/*==============================================================*/
/* Index: I_FKK_GROUP_INSTANCE_270                              */
/*==============================================================*/
create index I_FKK_GROUP_INSTANCE_270 on USER_PRODUCT.GROUP_INSTANCE_MEMBER
(
   GROUP_ID
);

/*==============================================================*/
/* Index: I_FKK_LIFE_CYCLE_271                                  */
/*==============================================================*/
create index I_FKK_LIFE_CYCLE_271 on USER_PRODUCT.GROUP_INSTANCE_MEMBER
(
   LIFE_CYCLE_ID
);

/*==============================================================*/
/* Index: I_FKK_GROUP_MEMBER_TYPE_262                           */
/*==============================================================*/
create index I_FKK_GROUP_MEMBER_TYPE_262 on USER_PRODUCT.GROUP_INSTANCE_MEMBER
(
   MEMBER_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_GROUP_INSTANCE_ROLE_263                         */
/*==============================================================*/
create index I_FKK_GROUP_INSTANCE_ROLE_263 on USER_PRODUCT.GROUP_INSTANCE_MEMBER
(
   MEMBER_ROLE_ID
);

/*==============================================================*/
/* Index: I_FKK_SERV_264                                        */
/*==============================================================*/
create index I_FKK_SERV_264 on USER_PRODUCT.GROUP_INSTANCE_MEMBER
(
   SERV_ID
);

/*==============================================================*/
/* Table: GROUP_INSTANCE_ROLE                                   */
/*==============================================================*/
create table USER_PRODUCT.GROUP_INSTANCE_ROLE
(
   MEMBER_ROLE_ID       numeric(9,0) not null comment '唯一标识群组成员角色的编号',
   MEMBER_ROLE_NAME     varchar(50) not null comment '群组成员角色的名称',
   MEMBER_ROLE_DESC     varchar(250) not null comment '群组成员角色的描述',
   primary key (MEMBER_ROLE_ID)
);

alter table USER_PRODUCT.GROUP_INSTANCE_ROLE comment '群组实例成员在具体的业务类型中的角色，如VPN中的主号、从号，百千号群的起始号、结束号';

/*==============================================================*/
/* Table: GROUP_MEMBER_RELATION                                 */
/*==============================================================*/
create table GROUP_MEMBER_RELATION
(
   GROUP_RELATION_ID    numeric(9,0) not null,
   GROUP_MEMBER_A       numeric(9,0) not null,
   GROUP_MEMBER_Z       numeric(9,0) not null,
   RELATION_DESC        varchar(250) not null,
   primary key (GROUP_RELATION_ID)
);

/*==============================================================*/
/* Table: GROUP_MEMBER_TYPE                                     */
/*==============================================================*/
create table USER_PRODUCT.GROUP_MEMBER_TYPE
(
   MEMBER_TYPE_ID       numeric(9,0) not null comment '唯一标识群组成员的编号',
   MEMBER_TYPE_NAME     varchar(50) not null comment '群组成员类型的名称',
   MEMBER_TYPE_DESC     varchar(250) not null comment '对群组成员类型的描述',
   primary key (MEMBER_TYPE_ID)
);

alter table USER_PRODUCT.GROUP_MEMBER_TYPE comment '群组成员的取值类型，可以为主产品实例、号码、群组、自定义规则。可以根据情况增加新的类型。';

/*==============================================================*/
/* Table: GROUP_PRODUCT_DETAIL                                  */
/*==============================================================*/
create table GROUP_PRODUCT_DETAIL
(
   GROUP_MEMBER_ID      numeric(9,0) not null,
   PRODUCT_ID           numeric(9,0) not null comment '用于唯一标识产品/服务的内部编号',
   ELEMENT_TYPE         varchar(3) not null,
   ELEMENT_ID           numeric(9,0) not null,
   GROUP_ROLE_ID        numeric(9,0) not null,
   OBJECT_AMOUT_CEIL    numeric(8,0) not null,
   OBJECT_AMOUT_FLOOR   numeric(8,0) not null,
   primary key (GROUP_MEMBER_ID)
);

alter table GROUP_PRODUCT_DETAIL comment '3.0模型新加三个实体，从规格层面定义群组产品相关信息；产品类型增加了群组产品的类型。';

/*==============================================================*/
/* Table: GROUP_ROLE                                            */
/*==============================================================*/
create table GROUP_ROLE
(
   GROUP_ROLE_ID        numeric(9,0) not null,
   GROUP_ROLE_NAME      varchar(50) not null,
   ROLE_AMOUNT_CEIL     numeric(8,0) not null,
   ROLE_AMOUNT_FLOOR    numeric(8,0) not null,
   primary key (GROUP_ROLE_ID)
);

/*==============================================================*/
/* Table: HCODE                                                 */
/*==============================================================*/
create table USER_LOCATION.HCODE
(
   HEAD_ID              numeric(9,0) not null comment '号头标识',
   HEAD                 varchar(50) not null comment '号头',
   POLITICAL_REGION_ID  numeric(9,0) not null comment '区号标识',
   EMULATORY_PARTNER_ID numeric(9,0) not null default 0 comment '运营商的唯一标识。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (HEAD_ID)
);

alter table USER_LOCATION.HCODE comment 'H码定义表，手机号头与区号对应关系';

/*==============================================================*/
/* Index: I_FKK_POLITICAL_REGION_326                            */
/*==============================================================*/
create index I_FKK_POLITICAL_REGION_326 on USER_LOCATION.HCODE
(
   POLITICAL_REGION_ID
);

/*==============================================================*/
/* Index: I_FKK_EMULATORY_PARTNER_330                           */
/*==============================================================*/
create index I_FKK_EMULATORY_PARTNER_330 on USER_LOCATION.HCODE
(
   EMULATORY_PARTNER_ID
);

/*==============================================================*/
/* Table: IDEP_INFO                                             */
/*==============================================================*/
create table IDEP_INFO
(
   IDEP_ID              numeric(9,0) not null comment 'IDEP标识',
   IDEP_CODE            varchar(15) not null comment 'IDEP唯一编码',
   IDEP_NAME            varchar(50) comment 'IDEP名称
            ',
   SC_ID                numeric(9,0) not null comment 'IDEP所属的SC标识',
   REGION_ID            numeric(9,0) comment '唯一标识区域的编号',
   REGION_NAME          varchar(50) not null comment 'IDEP所属地域的名称',
   IP_ADD               varchar(20) not null comment 'IP地址',
   PORT                 varchar(20) not null comment '端口号',
   STATE                varchar(20) not null comment 'IDEP的状态。包括登记、激活、去激活、注销',
   DATE                 datetime not null comment '当前状态开始的日期',
   primary key (IDEP_ID)
);

alter table IDEP_INFO comment '描述智能数据交换平台（IDEP）的基本信息。IDEP负责计费网控制与业务请求的路由转发。';

/*==============================================================*/
/* Table: INDIVIDUAL                                            */
/*==============================================================*/
create table PARTY_USER.INDIVIDUAL
(
   INDIVIDUAL_ID        numeric(12,0) not null comment '个人标识',
   GENDER               varchar(1) not null comment '性别：男、女',
   BIRTH_PLACE          varchar(30) not null comment '籍贯',
   BIRTH_DATE           datetime not null comment '个人的生日。',
   MARITAL_STATUS       varchar(3) not null comment '婚否',
   SKILL                varchar(250) not null comment '描述个人的专业特长',
   primary key (INDIVIDUAL_ID)
);

alter table PARTY_USER.INDIVIDUAL comment '个人是指一个独立的自然人，包括成人和小孩。';

/*==============================================================*/
/* Index: I_FKK_PARTY_181                                       */
/*==============================================================*/
create index I_FKK_PARTY_181 on PARTY_USER.INDIVIDUAL
(
   INDIVIDUAL_ID
);

/*==============================================================*/
/* Table: INDUSTRY                                              */
/*==============================================================*/
create table PARTY_USER.INDUSTRY
(
   INDUSTRY_ID          numeric(9,0) not null comment '行业的唯一标识。',
   INDUSTRY_NAME        varchar(50) not null comment '行业的名称。',
   primary key (INDUSTRY_ID)
);

alter table PARTY_USER.INDUSTRY comment '本实体记录了行业数据字典代码和名称的对应关系。';

/*==============================================================*/
/* Table: INTEGRAL_REAULT_DETAIL                                */
/*==============================================================*/
create table PARTY_USER.INTEGRAL_REAULT_DETAIL
(
   INTEGRAL_RESULT_DEATIL_ID numeric(12,0) not null comment '积分评估结果明细标识',
   EVAL_RULE_ID         numeric(9,0) comment '评估规则标识',
   OBJECT_TYPE          varchar(3) not null comment '对象类型',
   OBJECT_ID            numeric(12,0) comment '对象标识',
   ACCT_MONTH           varchar(6) not null comment '帐务月份',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '帐务周期标识',
   primary key (INTEGRAL_RESULT_DEATIL_ID)
);

alter table PARTY_USER.INTEGRAL_REAULT_DETAIL comment '描述积分评估结果明细';

/*==============================================================*/
/* Index: I_FKK_EVAL_RULE_277                                   */
/*==============================================================*/
create index I_FKK_EVAL_RULE_277 on PARTY_USER.INTEGRAL_REAULT_DETAIL
(
   EVAL_RULE_ID
);

/*==============================================================*/
/* Table: INTEGRAL_RESULT                                       */
/*==============================================================*/
create table PARTY_USER.INTEGRAL_RESULT
(
   INTEGRAL_REAULT_ID   numeric(12,0) not null comment '积分评估结果标识',
   OBJECT_TYPE          varchar(3) not null comment '对象类型',
   OBJECT_ID            numeric(12,0) not null comment '对象标识',
   CURRENT_INTEGRAL_VALUE numeric(8,0) comment '本周期积分',
   ACC_AMOUNT           numeric(8,0) comment '累计积分',
   PRESENT_VALUE        numeric(8,0) comment '已回馈积分',
   EXCEPTION_AMOUNT     numeric(8,0) comment '异常调分',
   primary key (INTEGRAL_REAULT_ID)
);

alter table PARTY_USER.INTEGRAL_RESULT comment '对积分结果明细的汇总';

/*==============================================================*/
/* Table: INTEGRAL_TYPE                                         */
/*==============================================================*/
create table USER_PRICING.INTEGRAL_TYPE
(
   INTEGRAL_TYPE_ID     numeric(9,0) not null comment '积分类型标识',
   USER_INTEGRAL_RESULT_ID numeric(12,0) comment '用户积分标识',
   INTEGRAL_TYPE_NAME   varchar(50) not null comment '积分类型名称',
   INTEGRAL_TYPE_TYPE   varchar(3) not null comment '积分类型类别',
   primary key (INTEGRAL_TYPE_ID)
);

alter table USER_PRICING.INTEGRAL_TYPE comment '描述积分类型，比如消费积分，奖励积分等';

/*==============================================================*/
/* Table: INTERNAL_STRUCT_ITEM2                                 */
/*==============================================================*/
create table USER_STAT.INTERNAL_STRUCT_ITEM2
(
   INTERNAL_TREE_NODE_ID numeric(9,0) comment '内部树节点标识',
   FACT_COLUMN1         varchar(30) not null comment '顶层中间层表字段1',
   REF_NODE_ID1         varchar(30) not null comment '指标参考节点1',
   FACT_COLUMN2         varchar(30) not null comment '顶层中间层表字段2',
   REF_NODE_ID2         varchar(30) not null comment '指标参考节点2',
   FACT_COLUMN3         varchar(30) not null comment '顶层中间层表字段3',
   REF_NODE_ID3         varchar(30) not null comment '指标参考节点3',
   FACT_COLUMN4         varchar(30) not null comment '顶层中间层表字段4',
   REF_NODE_ID4         varchar(30) not null comment '指标参考节点4',
   FACT_COLUMN5         varchar(30) not null comment '顶层中间层表字段5',
   REF_NODE_ID5         varchar(30) not null comment '指标参考节点5',
   FACT_COLUMN6         varchar(30) not null comment '顶层中间层表字段6',
   REF_NODE_ID6         varchar(30) not null comment '指标参考节点6',
   FACT_COLUMN7         varchar(30) not null comment '顶层中间层表字段7',
   REF_NODE_ID7         varchar(30) not null comment '指标参考节点7',
   FACT_COLUMN8         varchar(30) not null comment '顶层中间层表字段8',
   REF_NODE_ID8         varchar(30) not null comment '指标参考节点8',
   FACT_COLUMN9         varchar(30) not null comment '顶层中间层表字段9',
   REF_NODE_ID9         varchar(30) not null comment '指标参考节点9',
   FACT_COLUMN10        varchar(30) not null comment '顶层中间层表字段10',
   REF_NODE_ID10        varchar(30) not null comment '指标参考节点10'
);

alter table USER_STAT.INTERNAL_STRUCT_ITEM2 comment '定义内部树节点与原子树叶子取值关系表,内部树与原子树的引用关系通过这个实体表示';

/*==============================================================*/
/* Index: I_FKK_INTERNAL_TREE_STRUCT_357                        */
/*==============================================================*/
create index I_FKK_INTERNAL_TREE_STRUCT_357 on USER_STAT.INTERNAL_STRUCT_ITEM2
(
   INTERNAL_TREE_NODE_ID
);

/*==============================================================*/
/* Table: INTERNAL_TREE_STRUCT2                                 */
/*==============================================================*/
create table USER_STAT.INTERNAL_TREE_STRUCT2
(
   INTERNAL_TREE_NODE_ID numeric(9,0) not null comment '内部树节点标识',
   INTERNAL_TREE_ID     numeric(9,0) not null comment '内部树的目录标识',
   INTERNAL_NODE_LEVEL  numeric(5,0) not null comment '树层次级别',
   INTERNAL_NODE_ID     varchar(30) not null comment '节点编码',
   INTERNAL_NODE_NAME   varchar(50) not null comment '节点名称',
   SOURCE_FLAG          numeric(5,0) not null comment '节点数据来源标识
            1：直接计算：引用参数目录（原子树）的计算方式，在生成顶层中间层时已经将原子树更新到row字段，通过Target_Struct_Item（指标组合关系）进行计算。
            2：指标内部计算：采用指标内部节点计算。
            ',
   SUM_FLAG             numeric(5,0) not null comment '节点计算标识
            Sum_flag=1：直接计算，约束条件：Source_flag in (1)
            说明：通过在Target_Struct_Item（指标组合关系）中定义指标与各个参数目录的引用关系，从顶层中间层中获得指标值。这种方式不需要维护Sum_Relation，而需要维护Target_Struct_Item_t（指标组合关系）。
            Sum_flag=2：层级计算，约束条件：Source_Flag In (2)
            说明：本层数据下的子节点的数据的直接相加之和计算得到本节点数据，这种方式不需要填写Sum_Relation中的表达式；
            Sum_flag=3：错层计算，约束条件：Source_Flag in (2)',
   SUM_RELATION         varchar(250) not null comment '节点计算关系式：本指标内的节点的计算表达式，
            比如：@101010@+@101020@，运算符支持＋，－，×，÷和括号',
   ATOM_TREE_NODE_ID    numeric(9,0) comment '原子树节点标识',
   FACT_TABLE_ID        numeric(9,0) comment '顶层中间层标识',
   TARGET_CODE          varchar(30) not null comment '指标代码',
   TARGET_UNIT          varchar(30) not null comment '指标单位，如元、次数、分钟、户等',
   TARGET_SEQ_ID        numeric(9,0) not null comment '指标序号',
   primary key (INTERNAL_TREE_NODE_ID)
);

alter table USER_STAT.INTERNAL_TREE_STRUCT2 comment '内部树的树状结构定义1. 维护内部树的树状结构，按照财务部、市场部、综合统计部门对指标统计的要求分别构建财';

/*==============================================================*/
/* Index: I_FKK_TARGET_TREE_354                                 */
/*==============================================================*/
create index I_FKK_TARGET_TREE_354 on USER_STAT.INTERNAL_TREE_STRUCT2
(
   INTERNAL_TREE_ID
);

/*==============================================================*/
/* Index: I_FKK_ATOM_TREE_STRUCT_359                            */
/*==============================================================*/
create index I_FKK_ATOM_TREE_STRUCT_359 on USER_STAT.INTERNAL_TREE_STRUCT2
(
   ATOM_TREE_NODE_ID
);

/*==============================================================*/
/* Index: I_FKK_FACT_TABLE_DEFINE_363                           */
/*==============================================================*/
create index I_FKK_FACT_TABLE_DEFINE_363 on USER_STAT.INTERNAL_TREE_STRUCT2
(
   FACT_TABLE_ID
);

/*==============================================================*/
/* Table: INVOICE                                               */
/*==============================================================*/
create table USER_ACCT.INVOICE
(
   INVOICE_ID           numeric(12,0) not null comment '为每张发票记录生成的唯一标识。',
   PAYMENT_ID           numeric(12,0) not null comment '该发票所属得付款流水号。',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '该发票打印的张务周期。',
   NAME                 varchar(50) not null comment '帐目来源的名称。',
   PARTY_ROLE_ID        numeric(9,0) not null comment '员工标识',
   BILL_FORMAT_CUSTOMIZE_ID numeric(12,0) comment '帐单定制标识',
   ACC_NBR              varchar(20) not null comment '设备外部编号。',
   AMOUNT               numeric(12,0) not null comment '要补收补退的金额。',
   COUNT                numeric(8,0) not null comment '发票包含的设备数量。',
   PRINT_COUNT          numeric(8,0) not null comment '发票已经打印的次数。',
   PRINT_FLAG           varchar(3) not null comment '标识是否允许再打印。',
   INVOICE_TYPE         varchar(3) not null comment '标识发票的种类。',
   primary key (INVOICE_ID)
);

alter table USER_ACCT.INVOICE comment '记录每张发票的关键信息。包括金额、打印次数等。';

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_74                                */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_74 on USER_ACCT.INVOICE
(
   BILLING_CYCLE_ID
);

/*==============================================================*/
/* Index: I_FKK_PAYMENT_75                                      */
/*==============================================================*/
create index I_FKK_PAYMENT_75 on USER_ACCT.INVOICE
(
   PAYMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_STAFF_146                                       */
/*==============================================================*/
create index I_FKK_STAFF_146 on USER_ACCT.INVOICE
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILL_FORMAT_CUSTOMI_288                         */
/*==============================================================*/
create index I_FKK_BILL_FORMAT_CUSTOMI_288 on USER_ACCT.INVOICE
(
   BILL_FORMAT_CUSTOMIZE_ID
);

/*==============================================================*/
/* Table: INVOICE_DETAIL                                        */
/*==============================================================*/
create table USER_ACCT.INVOICE_DETAIL
(
   INVOICE_ID           numeric(12,0) not null comment '为每张发票记录生成的唯一标识。',
   INVOICE_ITEM_ID      numeric(9,0) not null comment '发票打印的项目编号',
   ITEM_NAME            varchar(50) not null comment '项目对应的名称',
   ITEM_VALUE           varchar(250) not null comment '项目对应的值，费用项为金额，文本向为字符串，也可以为空，只有名称',
   primary key (INVOICE_ID, INVOICE_ITEM_ID)
);

alter table USER_ACCT.INVOICE_DETAIL comment '记录发票的详细信息';

/*==============================================================*/
/* Index: I_FKK_INVOICE_284                                     */
/*==============================================================*/
create index I_FKK_INVOICE_284 on USER_ACCT.INVOICE_DETAIL
(
   INVOICE_ID
);

/*==============================================================*/
/* Table: KEY_ID_DEFINE2                                        */
/*==============================================================*/
create table USER_STAT.KEY_ID_DEFINE2
(
   KEY_ID               numeric(9,0) not null comment '关键ID标识',
   KEY_EN_NAME          varchar(30) not null comment '字段的英文名称',
   KEY_CH_NAME          varchar(50) not null comment '字段的中文名称',
   ID_TYPE              numeric(5,0) not null comment '定义ID字段类别
            0  表示该关键ID是维度ID
            1　表示该关键ID是度量ID',
   SEQ_ID               numeric(5,0) not null comment '序列',
   primary key (KEY_ID)
);

alter table USER_STAT.KEY_ID_DEFINE2 comment '定义关键ID字段1系统ID(包括字段ID和度量ID）是构成系统数据结构和参数目录的基础，关键ID也是系统I';

/*==============================================================*/
/* Table: LICENSE                                               */
/*==============================================================*/
create table LICENSE
(
   LICENSE_ID           numeric(9,0) not null comment '许可证标识',
   LICENSE_NUM          varchar(20) not null comment '许可证唯一编号，统一由集团分配',
   LICENSE_KEY          varchar(20) not null comment '许可证密钥，用于鉴别许可证真伪',
   ISSUED_DATE          datetime not null comment '许可证发放日期',
   VALID_DATE           datetime not null comment '许可证生效日期',
   EXPIRED_DATE         datetime not null comment '许可证失效日期',
   primary key (LICENSE_ID)
);

alter table LICENSE comment '描述网元许可证书的基本信息。网元上线前必须提出许可证申请，通过审批，取得许可证后，方可接入计费网。许可证编号统一由集团分';

/*==============================================================*/
/* Table: LIFE_CYCLE                                            */
/*==============================================================*/
create table USER_PRICING.LIFE_CYCLE
(
   LIFE_CYCLE_ID        numeric(9,0) not null comment '生命周期的标识',
   STATE                varchar(3) not null comment '生命周期的状态。 表示关联节点的生命状态，如生效、失效等',
   EFF_TYPE             varchar(3) not null comment '生效方式：绝对日期生效方式，相对日期生效方式',
   RELATIVE_EFF_VALUE   numeric(9,0) comment '相对生效值',
   EXP_DATE             datetime comment '何时失效，为空时表示还没有决定何时生效',
   EFF_DATE             datetime comment '何时生效',
   RELATIVE_EXP_VALUE   numeric(9,0) comment '相对失效值',
   primary key (LIFE_CYCLE_ID)
);

alter table USER_PRICING.LIFE_CYCLE comment '用于定义定价域模型中相关实体的生命周期，以描述特定实体实例的生效时间、失效时间、时间偏移计算方式等。';

/*==============================================================*/
/* Table: LIFE_CYCLE2                                           */
/*==============================================================*/
create table USER_PRICING.LIFE_CYCLE2
(
   LIFE_CYCLE_ID        numeric(9,0) not null comment '生命周期的标识',
   STATE                varchar(3) not null comment '生命周期的状态。 表示关联节点的生命状态，如生效、失效等',
   EFF_TYPE             varchar(3) not null comment '生效方式：绝对日期生效方式，相对日期生效方式',
   EFF_DATE             datetime comment '何时生效',
   EXP_DATE             datetime comment '何时失效，为空时表示还没有决定何时生效',
   RELATIVE_EFF_VALUE   numeric(8,0) not null comment '相对生效值',
   RELATIVE_EXP_VALUE   numeric(9,0) comment '相对失效值',
   primary key (LIFE_CYCLE_ID)
);

alter table USER_PRICING.LIFE_CYCLE2 comment '用于定义定价域模型中相关实体的生命周期，以描述特定实体实例的生效时间、失效时间、时间偏移计算方式等。';

/*==============================================================*/
/* Table: LOCAL_HEAD                                            */
/*==============================================================*/
create table USER_LOCATION.LOCAL_HEAD
(
   HEAD_ID              numeric(9,0) not null comment '号头标识',
   HEAD                 varchar(50) not null comment '号头',
   EMULATORY_PARTNER_ID numeric(9,0) not null default 0 comment '运营商的唯一标识。',
   EXCHANGE_ID          numeric(9,0) not null comment '营业区标识',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (HEAD_ID)
);

alter table USER_LOCATION.LOCAL_HEAD comment '本地号头信息';

/*==============================================================*/
/* Index: I_FKK_BILLING_REGION_325                              */
/*==============================================================*/
create index I_FKK_BILLING_REGION_325 on USER_LOCATION.LOCAL_HEAD
(
   EXCHANGE_ID
);

/*==============================================================*/
/* Index: I_FKK_EMULATORY_PARTNER_332                           */
/*==============================================================*/
create index I_FKK_EMULATORY_PARTNER_332 on USER_LOCATION.LOCAL_HEAD
(
   EMULATORY_PARTNER_ID
);

/*==============================================================*/
/* Table: LOGICAL_ADDRESS                                       */
/*==============================================================*/
create table USER_LOCATION.LOGICAL_ADDRESS
(
   LOGICAL_ADDRESS_ID   numeric(9,0) not null comment '逻辑地址的唯一标识。',
   ADDRESS_ID           numeric(9,0) not null comment '发票上打印的投递地址信息。',
   LOGICAL_ADDRESS_TYPE varchar(3) not null comment '逻辑地址类型，一个逻辑地址类型可以有多个信息，如一个参与人可以有多个MAIL地址，多个联系电话。',
   LOGICAL_ADDRESS_DETAIL varchar(250) not null comment '逻辑地址详细信息',
   primary key (LOGICAL_ADDRESS_ID)
);

alter table USER_LOCATION.LOGICAL_ADDRESS comment '描述参与人及产品的逻辑地址。';

/*==============================================================*/
/* Index: I_FKK_ADDRESS_180                                     */
/*==============================================================*/
create index I_FKK_ADDRESS_180 on USER_LOCATION.LOGICAL_ADDRESS
(
   ADDRESS_ID
);

/*==============================================================*/
/* Table: MAKET_STRATEGY                                        */
/*==============================================================*/
create table USER_PRODUCT.MAKET_STRATEGY
(
   STRATEGY_ID          numeric(9,0) not null comment '市场策略的唯一标识',
   STRATEGY_NAME        varchar(50) not null comment '市场策略的中文名称',
   STRATEGY_DETAIL      varchar(250) not null comment '市场策略的详细文字描述',
   STATE                varchar(3) comment '市场策略的状态。 当前记录的状态',
   EFF_DATE             datetime not null comment '当前策略的生效时间',
   EXP_DATE             datetime comment '当前策略的失效时间',
   primary key (STRATEGY_ID)
);

alter table USER_PRODUCT.MAKET_STRATEGY comment '描述推出销售品所要达到的市场目的和策略';

/*==============================================================*/
/* Table: MEASURE_METHOD                                        */
/*==============================================================*/
create table USER_PRICING.MEASURE_METHOD
(
   MEASURE_METHOD_ID    numeric(9,0) not null comment '度量方法的标识',
   MEASURE_METHOD_NAME  varchar(50) not null comment '度量方法的名称，说明是哪种算法的度量方法',
   primary key (MEASURE_METHOD_ID)
);

alter table USER_PRICING.MEASURE_METHOD comment '描述计价度量的方法，例如时长可以分为小时、分钟、秒、跳次等不同的计价度量单位。';

/*==============================================================*/
/* Table: MID_ID_DEFINE2                                        */
/*==============================================================*/
create table USER_STAT.MID_ID_DEFINE2
(
   KEY_ID               numeric(9,0) comment '关键ID标识',
   MID_TABLE_ID         numeric(9,0) comment '中间层标识',
   MID_TYPE             varchar(30) not null comment '中间层的分类，按收入类、欠费类、业务量类、已收类进行分类',
   ID_SEQ               numeric(5,0) not null comment '序列号',
   primary key (KEY_ID)
);

alter table USER_STAT.MID_ID_DEFINE2 comment '定义中间层的分类及中间层包含关键ID的信息';

/*==============================================================*/
/* Index: I_FKK_KEY_ID_DEFINE_350                               */
/*==============================================================*/
create index I_FKK_KEY_ID_DEFINE_350 on USER_STAT.MID_ID_DEFINE2
(
   KEY_ID
);

/*==============================================================*/
/* Index: I_FKK_MID_TABLE_DEFINE_362                            */
/*==============================================================*/
create index I_FKK_MID_TABLE_DEFINE_362 on USER_STAT.MID_ID_DEFINE2
(
   MID_TABLE_ID
);

/*==============================================================*/
/* Table: MID_TABLE_COLUMN2                                     */
/*==============================================================*/
create table USER_STAT.MID_TABLE_COLUMN2
(
   MID_TABLE_ID         numeric(9,0) not null comment '中间层标识',
   MID_COLUMN_EN_NAME   varchar(30) not null comment '中间层字段列名，如账目为acct_item_type_id',
   MID_COLUMN_CN_NAME   varchar(50) not null comment '中间层字段列的中文名',
   ID_SEQ               numeric(5,0) not null comment '该字段在同一个中间层表中的顺序',
   primary key (MID_TABLE_ID)
);

alter table USER_STAT.MID_TABLE_COLUMN2 comment '定义各个中间层包含的字段信息';

/*==============================================================*/
/* Index: I_FKK_MID_TABLE_DEFINE_351                            */
/*==============================================================*/
create index I_FKK_MID_TABLE_DEFINE_351 on USER_STAT.MID_TABLE_COLUMN2
(
   MID_TABLE_ID
);

/*==============================================================*/
/* Table: MID_TABLE_DEFINE2                                     */
/*==============================================================*/
create table USER_STAT.MID_TABLE_DEFINE2
(
   MID_TABLE_ID         numeric(9,0) not null comment '中间层标识',
   MID_TABLE_EN_NAME    varchar(30) not null comment '中间层的表名',
   MID_TYPE             varchar(30) not null comment '中间层的分类，按收入类、欠费类、业务量类、已收类进行分类',
   MID_TABLE_CN_NAME    varchar(50) not null comment '中间层表的名称',
   COMMENTS             varchar(250) not null comment '备注信息',
   primary key (MID_TABLE_ID)
);

alter table USER_STAT.MID_TABLE_DEFINE2 comment '定义中间层信息，定义中间层对应的表名和类别';

/*==============================================================*/
/* Table: MIN_INFO                                              */
/*==============================================================*/
create table MIN_INFO
(
   MIN_INFO_ID          numeric(9,0) not null,
   REGION_ID            numeric(9,0) comment '区域标识',
   PARTY_ROLE_ID        numeric(9,0) comment '运营商的唯一标识。',
   BEGIN_MIN            varchar(15) not null,
   END_MIN              varchar(15) not null,
   EFF_DATE             datetime not null,
   EXP_DATE             datetime not null,
   primary key (MIN_INFO_ID)
);

/*==============================================================*/
/* Table: NODE_INFO                                             */
/*==============================================================*/
create table NODE_INFO
(
   NODE_ID              numeric(9,0) not null comment '网元标识',
   NODE_CODE            varchar(15) not null comment '网元唯一编码，主要用于：识别网元；管理网元；网元间通讯；网元提供服务',
   NODE_NAME            varchar(50) comment '网元的名称，作为激活、去激活、路由查询的关键字，对应协议里面的NE-HOST。
            
            命名规则为：<NE-Name>.<DomainName>.ChinaTelecom.com
            
            如：VC1.ShangHai.ChinaTelecom.com',
   IDEP_ID              numeric(9,0) not null comment 'IDEP标识。网元与归属IDEP之间为永久长连接，不与其他SR连接。',
   LICENSE_ID           numeric(9,0) not null comment '许可证标识。网元上线前提出许可证申请, 通过审批，取得许可证后, 方可接入计费网。',
   REGION_ID            numeric(9,0) comment '唯一标识区域的编号',
   REGION_NAME          varchar(50) not null comment '网元所属地域的名称',
   IP_ADD               varchar(20) not null comment 'IP地址',
   PORT                 varchar(20) not null comment '端口号',
   STATE                varchar(20) not null comment '网元状态。包括登记、激活、去激活、注销',
   STATE_DATE           datetime not null comment '当前状态开始的日期',
   NODE_DESC            varchar(250) not null,
   primary key (NODE_ID)
);

alter table NODE_INFO comment '描述业务网元的基本信息。包括除IDEP、SC等传输、管理类网元外的所有网元。网元之间存在一定的层次关系。';

/*==============================================================*/
/* Index: idx_NodeInfo_NodeName                                 */
/*==============================================================*/
create unique index idx_NodeInfo_NodeName on NODE_INFO
(
   NODE_NAME
);

/*==============================================================*/
/* Table: OCS_RESERVE_EVENT_GRP                                 */
/*==============================================================*/
create table OCS_RESERVE_EVENT_GRP
(
   EVT_TYPE_GRP_ID      numeric(9,0) not null,
   EVT_TYPE_GRP_NAME    varchar(50) not null,
   INF_DESCRIBE         varchar(250) not null,
   primary key (EVT_TYPE_GRP_ID)
);

alter table OCS_RESERVE_EVENT_GRP comment '将计费帐务事件分组以配置预留策略。预留策略和第几次预留也有关系，同一个会话的不同次数的预留单元可以不同。';

/*==============================================================*/
/* Table: OCS_RESERVE_EVENT_GRP_MEMBER                          */
/*==============================================================*/
create table OCS_RESERVE_EVENT_GRP_MEMBER
(
   EVT_TYPE_GRP_ID      numeric(9,0) not null comment '事件类型分组标识',
   EVENT_TYPE_ID        numeric(9,0) not null comment '计费事件类型标识',
   primary key (EVT_TYPE_GRP_ID)
);

/*==============================================================*/
/* Table: OCS_RESERVE_LIMIT                                     */
/*==============================================================*/
create table OCS_RESERVE_LIMIT
(
   EVT_TYPE_GRP_ID      numeric(9,0) not null,
   EVENT_TYPE_ID        numeric(9,0) not null,
   EVENT_ATTR_ID        numeric(9,0) not null,
   VALUE                numeric(12,0) not null,
   BAL_LIMIT            numeric(12,0) not null,
   primary key (EVT_TYPE_GRP_ID, EVENT_ATTR_ID)
);

alter table OCS_RESERVE_LIMIT comment '最小预留，Session的最小预留额，小于等于这个值，返回余额不足，没有配置说明没有限制。一个预留策略事件组的一种事件属';

/*==============================================================*/
/* Table: OCS_RESERVE_POLICY                                    */
/*==============================================================*/
create table OCS_RESERVE_POLICY
(
   SEQ                  numeric(9,0) not null,
   EVT_TYPE_GRP_ID      numeric(9,0) not null,
   VALUE                numeric(12,0),
   EVENT_ATTR_ID        numeric(9,0) not null,
   EVENT_TYPE_ID        numeric(9,0) not null,
   primary key (SEQ, EVT_TYPE_GRP_ID, EVENT_TYPE_ID)
);

alter table OCS_RESERVE_POLICY comment '该表用于根据计费帐务事件及其属性设置相应的预留策略，预留策略与预留请求次数也有关系。';

/*==============================================================*/
/* Table: OPERATOR                                              */
/*==============================================================*/
create table USER_PRICING.OPERATOR
(
   OPERATOR_ID          numeric(9,0) not null comment '条件运算符的标识',
   OPERATOR_NAME        varchar(50) not null comment '条件运算符名称',
   primary key (OPERATOR_ID)
);

alter table USER_PRICING.OPERATOR comment '用于描述定价域模型所支持的用于进行逻辑判断的运算符，如大于、等于、小于等。';

/*==============================================================*/
/* Table: ORGANIZATION                                          */
/*==============================================================*/
create table PARTY_USER.ORGANIZATION
(
   ORG_ID               numeric(12,0) not null comment '组织标识',
   PARENT_ORGID         numeric(12,0) not null comment '上级组织标识，为0时表示该组织为最上层组织。',
   ORG_TYPE             varchar(3) not null comment '组织类型',
   REGION_ID            numeric(9,0) not null comment '对没有的，允许为空',
   ORG_CONTENT          varchar(250) not null comment '组织简介，描述组织的人员情况、职责、在企业中的位置。',
   primary key (ORG_ID)
);

alter table PARTY_USER.ORGANIZATION comment '组织是指一群具有共同兴趣和目标个人，包括：企事业单位、政府等。';

/*==============================================================*/
/* Index: I_FKK_REGION_338                                      */
/*==============================================================*/
create index I_FKK_REGION_338 on PARTY_USER.ORGANIZATION
(
   REGION_ID
);

/*==============================================================*/
/* Index: I_FKK_PARTY_182                                       */
/*==============================================================*/
create index I_FKK_PARTY_182 on PARTY_USER.ORGANIZATION
(
   ORG_ID
);

/*==============================================================*/
/* Index: I_FKK_ORGANIZATION_183                                */
/*==============================================================*/
create index I_FKK_ORGANIZATION_183 on PARTY_USER.ORGANIZATION
(
   PARENT_ORGID
);

/*==============================================================*/
/* Table: OWE_BUSINESS_TYPE                                     */
/*==============================================================*/
create table USER_ACCT.OWE_BUSINESS_TYPE
(
   OWE_BUSINESS_TYPE_ID numeric(9,0) not null comment '欠费业务类型的唯一标识。',
   OWE_BUSINESS_TYPE_NAME varchar(50) not null comment '欠费业务类型的名称。',
   STANDARD_CODE        varchar(15) not null comment '单位间隔数，即几个单位为一个帐务周期。',
   LEVEL                varchar(3) not null comment '表示各类欠费处理业务的级别，值越大，表示处理类型越高，如果主产品已经处于高级别状态，那么低于此级别的就不需要进行处理了。',
   primary key (OWE_BUSINESS_TYPE_ID)
);

alter table USER_ACCT.OWE_BUSINESS_TYPE comment '由于目前客户可以采用预付费和后付费两种方式，如果采用后付费方式进行付费时，可以允许客户在消费一定金额才进行超额处理，那么';

/*==============================================================*/
/* Table: OWE_DATETYPE_INFO                                     */
/*==============================================================*/
create table USER_ACCT.OWE_DATETYPE_INFO
(
   OWE_TIME_INFO_ID     numeric(9,0) not null comment '处理时间信息的唯一标识。',
   DATE_TYPE_ID         numeric(9,0) not null comment '欠费处理的时间类型的唯一标识。',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '帐务周期的标识，与帐务周期实体的BILLING_CYCLE_ID对应',
   REGION_ID            numeric(9,0) not null comment '区域标识',
   DATE                 datetime not null comment '具体日期',
   primary key (OWE_TIME_INFO_ID)
);

alter table USER_ACCT.OWE_DATETYPE_INFO comment '对于不同本地网，欠费处理时间类型的值可能不一样，因此需要进行不同的定义。';

/*==============================================================*/
/* Index: I_FKK_OWE_DATE_TYPE_81                                */
/*==============================================================*/
create index I_FKK_OWE_DATE_TYPE_81 on USER_ACCT.OWE_DATETYPE_INFO
(
   DATE_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_129                               */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_129 on USER_ACCT.OWE_DATETYPE_INFO
(
   BILLING_CYCLE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_REGION_130                              */
/*==============================================================*/
create index I_FKK_BILLING_REGION_130 on USER_ACCT.OWE_DATETYPE_INFO
(
   REGION_ID
);

/*==============================================================*/
/* Table: OWE_DATE_TYPE                                         */
/*==============================================================*/
create table USER_ACCT.OWE_DATE_TYPE
(
   DATE_TYPE_ID         numeric(9,0) not null comment '欠费时间类型的唯一标识。',
   DATE_TYPE_CODE       varchar(15) not null comment '欠费时间类型的标准编码。',
   DATE_TYPE_NAME       varchar(50) not null comment '欠费时间类型的名称。',
   primary key (DATE_TYPE_ID)
);

alter table USER_ACCT.OWE_DATE_TYPE comment '对于不同产品类型、不同欠费处理类型等，对应的参考时间点可能不一样，因此需要进行不同的定义；目前欠费处理类型是可定义的，那';

/*==============================================================*/
/* Table: OWE_OBJECT                                            */
/*==============================================================*/
create table USER_ACCT.OWE_OBJECT
(
   OWE_OBJECT_ID        numeric(9,0) not null comment '欠费处理对象的唯一标识。',
   OWE_OBJECT_TYPE      varchar(3) not null comment '欠费处理的对象类型。',
   OWE_OBJECT_DESC      varchar(250) not null comment '欠费处理对象的具体文字描述。',
   primary key (OWE_OBJECT_ID)
);

alter table USER_ACCT.OWE_OBJECT comment '每个欠费任务处理的对象可能是不同，因此本实体主要是描述欠费处理任务与处理对象实体之间的对应关系。';

/*==============================================================*/
/* Table: OWE_TASK                                              */
/*==============================================================*/
create table USER_ACCT.OWE_TASK
(
   OWE_TASK_ID          numeric(9,0) not null comment '欠费处理任务的唯一标识。',
   TIME_INFO_ID         numeric(9,0) not null comment '处理时间信息的唯一标识。',
   OWE_BUSINESS_TYPE_ID numeric(9,0) not null comment '欠费业务类型的唯一标识。',
   OWE_TASK_NAME        varchar(50) not null comment '欠费处理任务名称',
   UNIT                 varchar(3) not null comment '处理周期（其中“M”代表月，“W”代表周，“D”代表天）',
   OFFSET               numeric(5,0) not null comment '处理周期偏移量（选用“月”时，偏移量为1-31，选用“周”时，偏移量为1-7，选用“天”时，偏移量为1）',
   TIME                 datetime not null comment '处理时间（格式为HH24:MM，精确到分）',
   primary key (OWE_TASK_ID)
);

alter table USER_ACCT.OWE_TASK comment '由于存在不同欠费处理类型，不同的欠费处理类型处理时间、处理对象、处理条件肯定不一样，同时对于相同的欠费处理类型，处理时间';

/*==============================================================*/
/* Index: I_FKK_OWE_BUSINESS_TYPE_127                           */
/*==============================================================*/
create index I_FKK_OWE_BUSINESS_TYPE_127 on USER_ACCT.OWE_TASK
(
   OWE_BUSINESS_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_OWE_DATETYPE_INFO_128                           */
/*==============================================================*/
create index I_FKK_OWE_DATETYPE_INFO_128 on USER_ACCT.OWE_TASK
(
   TIME_INFO_ID
);

/*==============================================================*/
/* Table: OWE_TASK_OBJECT                                       */
/*==============================================================*/
create table USER_ACCT.OWE_TASK_OBJECT
(
   OWE_TASK_ID          numeric(12,0) not null comment '表示各类欠费处理业务的级别，值越大，表示处理类型越高，如果主产品已经处于高级别状态，那么低于此级别的就不需要进行处理了。',
   OWE_OBJECT_ID        numeric(12,0) not null comment '欠费处理对象标识',
   primary key (OWE_TASK_ID, OWE_OBJECT_ID)
);

alter table USER_ACCT.OWE_TASK_OBJECT comment '欠费处理任务和处理对象的关联表';

/*==============================================================*/
/* Index: I_FKK_OWE_TASK_85                                     */
/*==============================================================*/
create index I_FKK_OWE_TASK_85 on USER_ACCT.OWE_TASK_OBJECT
(
   OWE_TASK_ID
);

/*==============================================================*/
/* Index: I_FKK_OWE_OBJECT_86                                   */
/*==============================================================*/
create index I_FKK_OWE_OBJECT_86 on USER_ACCT.OWE_TASK_OBJECT
(
   OWE_OBJECT_ID
);

/*==============================================================*/
/* Table: OWE_TYPE_ACCTTYPE                                     */
/*==============================================================*/
create table USER_ACCT.OWE_TYPE_ACCTTYPE
(
   ACCT_ITEM_TYPE_ID    numeric(9,0) not null comment '电信产品服务费用中的其中一种费用类型。',
   OWE_BUSINESS_TYPE_ID numeric(9,0) comment '欠费业务类型的唯一标识。',
   primary key (ACCT_ITEM_TYPE_ID)
);

alter table USER_ACCT.OWE_TYPE_ACCTTYPE comment '定义每个欠费处理类型处理时参与的帐目类型，例如停来电显示时只选用来电信显示的费用。';

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_TYPE_120                              */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_TYPE_120 on USER_ACCT.OWE_TYPE_ACCTTYPE
(
   ACCT_ITEM_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_OWE_BUSINESS_TYPE_131                           */
/*==============================================================*/
create index I_FKK_OWE_BUSINESS_TYPE_131 on USER_ACCT.OWE_TYPE_ACCTTYPE
(
   OWE_BUSINESS_TYPE_ID
);

/*==============================================================*/
/* Table: OWE_TYPE_LIMIT                                        */
/*==============================================================*/
create table USER_ACCT.OWE_TYPE_LIMIT
(
   OWE_TYPE_LIMIT_ID    numeric(9,0) not null comment '欠费类型限额的唯一标识。',
   OWE_BUSINESS_TYPE_ID numeric(9,0) not null comment '欠费业务类型的唯一标识。',
   CREDIT_CEIL          numeric(5,0) not null comment '表示信用度阀值上限',
   CREDIT_FLOOR         numeric(5,0) not null comment '表示信用度阀值下限',
   QUANTITY             numeric(12,0) not null comment '表示欠费额度，以分为单位',
   primary key (OWE_TYPE_LIMIT_ID)
   );

alter table USER_ACCT.OWE_TYPE_LIMIT comment '定义每个欠费处理类型针对不同信用度的客户的欠费总额.';

/*==============================================================*/
/* Index: I_FKK_OWE_BUSINESS_TYPE_126                           */
/*==============================================================*/
create index I_FKK_OWE_BUSINESS_TYPE_126 on USER_ACCT.OWE_TYPE_LIMIT
(
   OWE_BUSINESS_TYPE_ID
);

/*==============================================================*/
/* Table: OWNER                                                 */
/*==============================================================*/
create table USER_PRICING.OWNER
(
   OWNER_ID             numeric(9,0) not null comment '属主的标识',
   OWNER_OBJECT_TYPE    varchar(3) not null comment '包括本产品实例,本客户,本帐户,本事件,销售品对象、具有某些相同属性的产品实例集合的产品实例集合等。',
   CHARGE_PARTY_ID      varchar(3) not null comment '属主属性必须要分出是主叫对应的属主还是被叫对应的属主，比如：主叫、被叫、第三方、指定号码等。
            ',
   primary key (OWNER_ID)
);

alter table USER_PRICING.OWNER comment '属主定义表用于定义定价参考对象归属的具体实例，如属主可以是产品实例、客户实例或事件实例等。';

/*==============================================================*/
/* Table: PARTNER                                               */
/*==============================================================*/
create table PARTY_USER.PARTNER
(
   PARTY_ID             numeric(9,0) not null comment '合作伙伴的唯一标识。',
   PARD_CODE            varchar(15) not null comment '合作伙伴的标准外部编码。',
   PARD_TYPE            varchar(3) not null comment '合作伙伴类型：设备供应商、服务提供商、虚拟运营商。',
   PARD_DESC            varchar(250) not null comment '合作伙伴的具体文字描述。',
   primary key (PARTY_ID)
);

alter table PARTY_USER.PARTNER comment '合作伙伴是指在电信业务活动中与中国电信拥有共同的目标和利益并承担相应职责的组织。根据合作性质可以分为：设备供应商、服务提';

/*==============================================================*/
/* Index: I_FKK_PARTY_ROLE_186                                  */
/*==============================================================*/
create index I_FKK_PARTY_ROLE_186 on PARTY_USER.PARTNER
(
   PARTY_ID
);

/*==============================================================*/
/* Table: PARTNER_ACCT_ITEM                                     */
/*==============================================================*/
create table USER_ACCT.PARTNER_ACCT_ITEM
(
   PARTNER_ACCT_ITEM_ID numeric(12,0) not null comment '为不同帐目生成的唯一编号。',
   ACCT_ITEM_TYPE_ID    numeric(9,0) not null comment '电信产品服务费用中的其中一种费用类型。',
   AMOUNT               numeric(12,0) not null comment '改cpsp这个业务代码金额。',
   STATE                varchar(3) not null comment '帐目的状态。',
   LATN_ID              numeric(9,0) not null comment '帐目所在的本地网，主要用于异地付费',
   PARTNER_ID           numeric(9,0) not null,
   SERVICE_CODE         varchar(15) not null,
   ACCT_ITEM_ID         numeric(12,0) not null,
   primary key (PARTNER_ACCT_ITEM_ID)
);

alter table USER_ACCT.PARTNER_ACCT_ITEM comment '表示SP/CP的帐目数据，用于SP/CP的结算，物理落地方式留给厂家自己根据需要实现';

/*==============================================================*/
/* Index: I_FKK_BILLING_REGION_348                              */
/*==============================================================*/
create index I_FKK_BILLING_REGION_348 on USER_ACCT.PARTNER_ACCT_ITEM
(
   LATN_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_TYPE_62                               */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_TYPE_62 on USER_ACCT.PARTNER_ACCT_ITEM
(
   ACCT_ITEM_TYPE_ID
);



/*==============================================================*/
/* Table: PARTNER_AGREEMENT                                     */
/*==============================================================*/
create table PARTY_USER.PARTNER_AGREEMENT
(
   PARTNER_AGREEMENT_ID numeric(12,0) not null comment '合作伙伴协议标识',
   PARTNER_ID           numeric(9,0) not null comment '合作伙伴的唯一标识。',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   SIGN_DATE            datetime not null comment '协议签署时间。',
   ACCEPT_STAFF_ID      numeric(9,0) not null comment '电信公司签署协议的员工的工号。',
   STATE                varchar(3) not null comment '协议完成的状态。',
   COMMENTS             varchar(250) not null comment '客户协议的具体描述。',
   primary key (PARTNER_AGREEMENT_ID)
);

alter table PARTY_USER.PARTNER_AGREEMENT comment '合作伙伴签署的协议';

/*==============================================================*/
/* Index: I_FKK_PARTNER_283                                     */
/*==============================================================*/
create index I_FKK_PARTNER_283 on PARTY_USER.PARTNER_AGREEMENT
(
   PARTNER_ID
);

/*==============================================================*/
/* Table: PARTY                                                 */
/*==============================================================*/
create table PARTY_USER.PARTY
(
   PARTY_ID             numeric(12,0) not null comment '参与人标识',
   PARTY_NAME           varchar(50) not null comment '描述参与人名称',
   EFF_DATE             datetime not null comment '产生时间',
   STATE                varchar(3) comment '参与人的状态。 记录状态：正常、作废',
   STATE_DATE           datetime not null comment '参与人状态变更的时间。',
   primary key (PARTY_ID)
);

alter table PARTY_USER.PARTY comment '参与人是指参与电信业务活动的所有个人或组织。';

/*==============================================================*/
/* Table: PARTY_IDENTIFICATION                                  */
/*==============================================================*/
create table PARTY_USER.PARTY_IDENTIFICATION
(
   IDENT_ID             numeric(12,0) not null comment '参与人识别信息的唯一标识。',
   PARTY_ID             numeric(9,0) not null comment '参与人标识',
   SOCIAL_ID_TYPE       varchar(3) not null comment '参与人社会标识类型如：身份证、护照、税务登记证等。',
   SOCIAL_ID            varchar(30) not null comment '社会标识码',
   CREATED_DATE         datetime not null comment '产生时间',
   EFF_DATE             datetime not null comment '参与人识别信息生效的时间。',
   EXP_DATE             datetime comment '参与人识别信息失效的时间。',
   primary key (IDENT_ID)
);

alter table PARTY_USER.PARTY_IDENTIFICATION comment '参与人标识是指用于唯一确定参与人身份的各种证件标识。例如个人公民身份证、企业的税务登记证等。';

/*==============================================================*/
/* Index: I_FKK_PARTY_102                                       */
/*==============================================================*/
create index I_FKK_PARTY_102 on PARTY_USER.PARTY_IDENTIFICATION
(
   PARTY_ID
);

/*==============================================================*/
/* Table: PARTY_ROLE                                            */
/*==============================================================*/
create table PARTY_USER.PARTY_ROLE
(
   PARTY_ROLE_ID        numeric(9,0) not null comment '参与人角色标识',
   PARTY_ROLE_NAME      varchar(50) not null comment '参与人角色名称',
   PARTY_ID             numeric(12,0) not null comment '参与人标识',
   PARTY_ROLE_TYPE      varchar(3) not null comment '参与人角色类型：电信内部参与人、竞争对手、合作伙伴',
   EFF_DATE             datetime not null comment '参与人角色生效的时间。',
   EXP_DATE             datetime comment '参与人角色失效的时间。',
   primary key (PARTY_ROLE_ID)
);

alter table PARTY_USER.PARTY_ROLE comment '参与人角色是对参与人在电信业务活动中所表现的行为和特征的分类归纳定义，包括：电信内部参与人、合作伙伴、对等运营商、客户。';

/*==============================================================*/
/* Index: I_FKK_PARTY_188                                       */
/*==============================================================*/
create index I_FKK_PARTY_188 on PARTY_USER.PARTY_ROLE
(
   PARTY_ID
);

/*==============================================================*/
/* Table: PAYMENT                                               */
/*==============================================================*/
create table USER_ACCT.PAYMENT
(
   PAYMENT_ID           numeric(12,0) not null comment '区分用户付款记录的唯一标识。',
   PAYMENT_METHOD       numeric(9,0) not null comment '为每种付款方式定义的唯一代码',
   PARTY_ROLE_ID        numeric(9,0) not null comment '员工标识',
   PAYED_METHOD         numeric(9,0) comment '实收交易的具体付款方式，分类较细，如前台现金、银行托收、银行实时托收、现金预付费、银行预付费、银行现金代收、缴费卡扣费等。',
   OPERATION_TYPE       varchar(3) not null comment '生成付款记录操作类别，如付款、冲正等。',
   OPERATED_PAYMENT_SERIAL_NBR numeric(12,0) not null comment '生成付款记录操作类别，如付款、冲正等。',
   AMOUNT               numeric(12,0) not null comment '要补收补退的金额。',
   PAYMENT_DATE         datetime not null comment '交易的总额。',
   STATE                varchar(3) not null comment '付款记录的状态。',
   STATE_DATE           datetime not null comment '付款记录状态变更的时间。',
   CREATED_DATE         datetime not null comment '数据生成日期',
   primary key (PAYMENT_ID)
);

alter table USER_ACCT.PAYMENT comment '记录帐户付款过程的相关信息。';

/*==============================================================*/
/* Index: I_FKK_PAYMENT_METHOD_122                              */
/*==============================================================*/
create index I_FKK_PAYMENT_METHOD_122 on USER_ACCT.PAYMENT
(
   PAYMENT_METHOD
);

/*==============================================================*/
/* Index: I_FKK_STAFF_147                                       */
/*==============================================================*/
create index I_FKK_STAFF_147 on USER_ACCT.PAYMENT
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Index: I_FKK_PAYMENT_METHOD_207                              */
/*==============================================================*/
create index I_FKK_PAYMENT_METHOD_207 on USER_ACCT.PAYMENT
(
   PAYED_METHOD
);

/*==============================================================*/
/* Table: PAYMENT_METHOD                                        */
/*==============================================================*/
create table USER_ACCT.PAYMENT_METHOD
(
   PAYMENT_METHOD       numeric(9,0) not null comment '为每种付款方式定义的唯一代码',
   PAYMENT_METHOD_NAME  varchar(50) not null comment '付款方式名称',
   primary key (PAYMENT_METHOD)
);

alter table USER_ACCT.PAYMENT_METHOD comment '定义具体的付款方式类型和名称';

/*==============================================================*/
/* Table: PAYMENT_PLAN                                          */
/*==============================================================*/
create table USER_ACCT.PAYMENT_PLAN
(
   PAYMENT_PLAN_ID      numeric(12,0) not null comment '支付方案的唯一标识。',
   ACCT_ID              numeric(12,0) comment '为每个帐户生成的唯一编号，只具有逻辑上的含义，没有物理意义。每个帐户标识生成之后，帐户标识在整个服务提供有效期内保持不变。',
   PAYMENT_METHOD       numeric(9,0) comment '为每种付款方式定义的唯一代码',
   PRIORITY             numeric(3,0) not null comment '当前帐户所定制的各付款方式的优先级',
   PAYMENT_PLAN_TYPE    varchar(3) comment '支付方案的类型，有现金、托收等',
   PAYMENT_SUPPLIE_ID   numeric(9,0) not null comment '该支付方案的帐户提供标识，当为现金时不填，为托收时，填对应的银行标识，为信用卡时，填对应的卡银行标识，等等。可根据需要自己扩充',
   PAYMENT_ACCT_NO      varchar(30) not null comment '该支付方式下对应的帐号，现金方式不用填写，托收方式填写银行帐号，信用卡方式填写信用卡号',
   PAYMENT_ACCT_CUST_NAME varchar(50) not null comment '对应帐号的具体名称',
   PAYMENT_ACCT_TYPE    varchar(3) not null comment '银行帐号的所属类型。',
   STATE                varchar(3) not null comment '银行托收支付方案的状态。',
   STATE_DATE           datetime not null comment '帐务定制关系状态变更的时间。',
   primary key (PAYMENT_PLAN_ID)
);

alter table USER_ACCT.PAYMENT_PLAN comment '定义帐户的各种支付方案，包括现金、银行托收、买断、信用卡等。';

/*==============================================================*/
/* Index: I_FKK_ACCT_286                                        */
/*==============================================================*/
create index I_FKK_ACCT_286 on USER_ACCT.PAYMENT_PLAN
(
   ACCT_ID
);

/*==============================================================*/
/* Index: I_FKK_PAYMENT_METHOD_287                              */
/*==============================================================*/
create index I_FKK_PAYMENT_METHOD_287 on USER_ACCT.PAYMENT_PLAN
(
   PAYMENT_METHOD
);

/*==============================================================*/
/* Table: PAYMENT_RULE                                          */
/*==============================================================*/
create table USER_ACCT.PAYMENT_RULE
(
   PAYMENT_RULE_ID      numeric(9,0) not null comment '为每个支付计划生成的唯一编号。',
   CUST_AGREEMENT_ID    numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   NAME                 varchar(50) not null comment '支付规则名称。',
   COMMENTS             varchar(250) not null comment '支付规则的中文描述。',
   primary key (PAYMENT_RULE_ID)
);

alter table USER_ACCT.PAYMENT_RULE comment '在客户协议中规定的有关客户的每种费用由哪个帐户支付的规则条目。客户可以通过客户协议、支付规则来查询或定制每类费用的支付帐';

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_119                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_119 on USER_ACCT.PAYMENT_RULE
(
   CUST_AGREEMENT_ID
);

/*==============================================================*/
/* Table: PAY_STRATEGY                                          */
/*==============================================================*/
create table PAY_STRATEGY
(
   PAY_RULE_ID          numeric(9,0) not null,
   TRADE_TYPE_ID        numeric(9,0),
   PAY_METHOD           numeric(9,0) not null comment '付费模式
            1、预付费
            2、后付费',
   QUOTA                numeric(12,0) not null,
   primary key (PAY_RULE_ID)
);

alter table PAY_STRATEGY comment '描述小额支付策略
如判断用户账本的钱是否够买指定商品时，是否考虑结合用户的付费方式，是否考虑用户的已发生费用';

/*==============================================================*/
/* Table: PLUSMINUS                                             */
/*==============================================================*/
create table USER_ACCT.PLUSMINUS
(
   PLUS_SEQ_NBR         numeric(12,0) not null comment '为每条补收补退记录生成的唯一标识。',
   ACC_NBR              varchar(20) not null comment '设备外部编号。',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '表明余额对象性质，可选客户/帐户/用户',
   ACCT_ITEM_TYPE_ID    numeric(9,0) not null comment '电信产品服务费用中的其中一种费用类型。',
   AMOUNT               numeric(12,0) not null comment '要补收补退的金额。',
   MERGE_FLAG           varchar(3) not null comment '是否已经合帐标志。',
   REASON               varchar(250) not null comment '补收补退原因。',
   MERGE_BALANCE        numeric(12,0) not null comment '合帐完后还剩余的金额。',
   FEE_CYCLE_ID         numeric(9,0) not null comment '要补收补退费用所属的帐务周期。',
   PARTY_ROLE_ID        numeric(9,0) not null comment '员工标识',
   CREATE_DATE          datetime not null comment '记录创建时间。',
   STATE                varchar(3) comment '补收补退的状态。',
   STATE_DATE           datetime not null comment '补收补退状态变更的时间。',
   primary key (PLUS_SEQ_NBR)
);

alter table USER_ACCT.PLUSMINUS comment '记录每个设备号码的补收补退信息。';

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_TYPE_71                               */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_TYPE_71 on USER_ACCT.PLUSMINUS
(
   ACCT_ITEM_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_76                                */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_76 on USER_ACCT.PLUSMINUS
(
   BILLING_CYCLE_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_144                               */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_144 on USER_ACCT.PLUSMINUS
(
   FEE_CYCLE_ID
);

/*==============================================================*/
/* Index: I_FKK_STAFF_145                                       */
/*==============================================================*/
create index I_FKK_STAFF_145 on USER_ACCT.PLUSMINUS
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Table: POLITICAL_REGION                                      */
/*==============================================================*/
create table USER_LOCATION.POLITICAL_REGION
(
   REGION_ID            numeric(9,0) not null comment '区域标识',
   PARENT_REGION_ID     numeric(9,0) comment '上级区域的唯一标识，用于表示层次关系。',
   REGION_LEVEL         varchar(3) not null comment '区域级别，越高级别的表明该区域越大。',
   REGION_CODE          varchar(30) not null comment '区域编码，可用于表示国家和地市的区号等',
   primary key (REGION_ID)
);

alter table USER_LOCATION.POLITICAL_REGION comment '描述行政区域可以用“位于”的关系进行如下描述：如国家->省(直辖市、自治区、特别行政区) ->城市->县（分局）。';

/*==============================================================*/
/* Index: I_FKK_POLITICAL_REGION_333                            */
/*==============================================================*/
create index I_FKK_POLITICAL_REGION_333 on USER_LOCATION.POLITICAL_REGION
(
   PARENT_REGION_ID
);

/*==============================================================*/
/* Index: I_FKK_REGION_334                                      */
/*==============================================================*/
create index I_FKK_REGION_334 on USER_LOCATION.POLITICAL_REGION
(
   REGION_ID
);

/*==============================================================*/
/* Table: PRERATE_EVENT                                         */
/*==============================================================*/
create table USER_EVENT.PRERATE_EVENT
(
   RATABLE_EVENT_ID     numeric(12,0) not null comment '计费事件的唯一标识。',
   EVENT_ID             numeric(12,0) not null comment '源事件标识，标识计费帐务事件的源事件',
   EVENT_TYPE_ID        numeric(9,0) not null comment '计费帐务事件类型的唯一标识。',
   EVENT_CONTENT_ID     numeric(12,0) not null comment '事件内容位置的唯一标识，由该位置标识找出事件内容具体位置',
   primary key (RATABLE_EVENT_ID)
);

alter table USER_EVENT.PRERATE_EVENT comment '预处理后计费事件（pre-processed event）是在计费预处理阶段，基于源事件（source_event）生成';

/*==============================================================*/
/* Index: I_FKK_EVENT_CONTENT_INDEX_305                         */
/*==============================================================*/
create index I_FKK_EVENT_CONTENT_INDEX_305 on USER_EVENT.PRERATE_EVENT
(
   EVENT_CONTENT_ID
);

/*==============================================================*/
/* Index: I_FKK_DEST_EVENT_TYPE_307                             */
/*==============================================================*/
create index I_FKK_DEST_EVENT_TYPE_307 on USER_EVENT.PRERATE_EVENT
(
   EVENT_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_SOURCE_EVENT_309                                */
/*==============================================================*/
create index I_FKK_SOURCE_EVENT_309 on USER_EVENT.PRERATE_EVENT
(
   EVENT_ID
);

/*==============================================================*/
/* Table: PRESENT                                               */
/*==============================================================*/
create table PARTY_USER.PRESENT
(
   PRESENT_ID           numeric(9,0) not null comment '赠品定义的唯一标识。',
   PRESENT_TYPE         varchar(3) not null comment '赠送的具体类别。',
   PRESENT_NAME         varchar(50) not null comment '赠品名称',
   INTEGRAL_VALUE       numeric(8,0) not null comment '所用的积分。',
   PRESENT_NUM          numeric(8,0) not null comment '单位礼品数',
   EFF_DATE             datetime not null comment '本记录的生效时间。',
   EXP_DATE             datetime comment '本记录的失效时间。',
   primary key (PRESENT_ID)
);

alter table PARTY_USER.PRESENT comment '描述积分兑换的可兑换物品情况，单位赠品抵扣的积分数。




                                       -&#&';

/*==============================================================*/
/* Table: PRICING_COMBINE                                       */
/*==============================================================*/
create table USER_PRICING.PRICING_COMBINE
(
   PRICING_COMBINE_ID   numeric(9,0) not null comment '定价组合的标识',
   PRICING_PLAN_ID      numeric(9,0) not null comment '指明本定价组合所归属的定价计划',
   EVENT_PRICING_STRATEGY_ID numeric(9,0) not null comment '指明当前定价计划包装了哪个事件定价策略',
   OFFER_OBJECT_ID      numeric(9,0) comment '包含对象的标识',
   LIF_LIFE_CYCLE_ID    numeric(9,0) comment '生命周期的标识',
   CALC_PRIORITY        numeric(3,0) not null comment '用于与定价组合关系配合，表达不同定价组合之间的计算顺序',
   primary key (PRICING_COMBINE_ID)
);

alter table USER_PRICING.PRICING_COMBINE comment '一个定价计划可由一个或多个事件定价策略组合而成，一个事件定价策略又可由一个或多个定价计划所引用，此实体描述了定价计划和定';

/*==============================================================*/
/* Index: I_FKK_EVENT_PRICING_STRAT__42                         */
/*==============================================================*/
create index I_FKK_EVENT_PRICING_STRAT__42 on USER_PRICING.PRICING_COMBINE
(
   EVENT_PRICING_STRATEGY_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_PLAN_43                                 */
/*==============================================================*/
create index I_FKK_PRICING_PLAN_43 on USER_PRICING.PRICING_COMBINE
(
   PRICING_PLAN_ID
);

/*==============================================================*/
/* Index: I_FKK_LIFE_CYCLE_51                                   */
/*==============================================================*/


/*==============================================================*/
/* Table: PRICING_COMBINE_RELATION                              */
/*==============================================================*/
create table USER_PRICING.PRICING_COMBINE_RELATION
(
   A_PRICING_COMBINE_ID numeric(9,0) not null comment '父定价组合的标识',
   Z_PRICING_COMBINE_ID numeric(9,0) not null comment '子定价组合的标识',
   RELATION_TYPE        varchar(3) not null comment '两个定价组合之间的关系类型，譬如互斥，关联',
   primary key (A_PRICING_COMBINE_ID, Z_PRICING_COMBINE_ID)
);

alter table USER_PRICING.PRICING_COMBINE_RELATION comment '定义定价组合的几种具体关系。';

/*==============================================================*/
/* Index: I_FKK_PRICING_COMBINE_52                              */
/*==============================================================*/
create index I_FKK_PRICING_COMBINE_52 on USER_PRICING.PRICING_COMBINE_RELATION
(
   A_PRICING_COMBINE_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_COMBINE_53                              */
/*==============================================================*/
create index I_FKK_PRICING_COMBINE_53 on USER_PRICING.PRICING_COMBINE_RELATION
(
   Z_PRICING_COMBINE_ID
);

/*==============================================================*/
/* Table: PRICING_ENUM_PARAM                                    */
/*==============================================================*/
create table USER_PRICING.PRICING_ENUM_PARAM
(
   ENUM_ID              numeric(9,0) not null comment '离散取值的标识',
   PRICING_PARAM_ID     numeric(9,0) not null comment '说明是哪个参数的离散取值，外键',
   PARAM_VALUE          varchar(30) not null comment '离散取值的具体数值',
   primary key (ENUM_ID)
);

alter table USER_PRICING.PRICING_ENUM_PARAM comment '用于定义枚举型参数可以赋予的有限取值的集合。';

/*==============================================================*/
/* Index: I_FKK_PRICING_PARAM_DEFINE_38                         */
/*==============================================================*/
create index I_FKK_PRICING_PARAM_DEFINE_38 on USER_PRICING.PRICING_ENUM_PARAM
(
   PRICING_PARAM_ID
);

/*==============================================================*/
/* Table: PRICING_PARAM_DEFINE                                  */
/*==============================================================*/
create table USER_PRICING.PRICING_PARAM_DEFINE
(
   PRICING_PARAM_ID     numeric(9,0) not null comment '参数的标识',
   PRICING_PARAM_NAME   varchar(50) not null comment '该参数的名称',
   DEFAULT_VALUE        varchar(30) not null comment '定价参数确省值',
   primary key (PRICING_PARAM_ID)
);

alter table USER_PRICING.PRICING_PARAM_DEFINE comment '用于描述进行资费计算或者优惠计算所涉及的可配置的参数。这些参数的取值可以在制定产品的定价计划时进行配置，也可以在客户购买';

/*==============================================================*/
/* Table: PRICING_PLAN                                          */
/*==============================================================*/
create table USER_PRICING.PRICING_PLAN
(
   PRICING_PLAN_ID      numeric(9,0) not null comment '定价计划的标识',
   PRICING_PLAN_NAME    varchar(50) not null comment '该定价计划的名称',
   PRICING_DESC         varchar(4000) not null comment '定价计划的资费说明。',
   PARAM_DESC           varchar(4000) not null comment '定价计划参数的说明。',
   PRICING_PLAN_TYPE    varchar(3) not null comment '定价计划类型',
   primary key (PRICING_PLAN_ID));

alter table USER_PRICING.PRICING_PLAN comment '定价计划是在产品成本、企业回报目的以及国家相关政策的基础上，结合企业市场营销计划而制定的针对产品/销售品的价格方案，它与';

/*==============================================================*/
/* Table: PRICING_REF_OBJECT                                    */
/*==============================================================*/
create table USER_PRICING.PRICING_REF_OBJECT
(
   PRICING_REF_OBJECT_ID numeric(9,0) not null comment '参考对象的标识',
   OWNER_ID             numeric(9,0) not null comment '属主标识，譬如，某个event，某个产品等',
   PROPERTY_TYPE        varchar(3) not null comment '属性类型，如金钱类、积量类、事件类、外部类等。
            ',
   PROPERTY_DEFINE_ID   numeric(9,0) comment '说明引用哪个属性，外键引用属性定义表',
   EXTERN_PROPERTY_STRING varchar(50) comment '定价参考对象的外部属性标识，用字符串表示。',
   MEASURE_METHOD_ID    numeric(9,0) comment '度量方法的标识',
   HISTORY_TIME_TYPE    varchar(3) not null comment '定价参考对象时间类型，如帐期、月份等，例如用于表达前两个月的费用总额',
   HISTORY_TIME_DURATION numeric(5,0) not null comment '定价参考对象时间偏移量，如向前第3个帐期，则取值＝－3',
   HISTORY_TIME_QUANTITY numeric(5,0) not null comment '定价参考对象所属的周期时间对象。',
   primary key (PRICING_REF_OBJECT_ID));

alter table USER_PRICING.PRICING_REF_OBJECT comment '在对产品/销售品进行定价的过程中所牵涉的对定价有影响的数据实体的相关参照属性，可以是（但不限于）产品、销售品、客户协议、';

/*==============================================================*/
/* Index: I_FKK_OWNER_20                                        */
/*==============================================================*/
create index I_FKK_OWNER_20 on USER_PRICING.PRICING_REF_OBJECT
(
   OWNER_ID
);

/*==============================================================*/
/* Index: I_FKK_MEASURE_METHOD_232                              */
/*==============================================================*/
create index I_FKK_MEASURE_METHOD_232 on USER_PRICING.PRICING_REF_OBJECT
(
   MEASURE_METHOD_ID
);

/*==============================================================*/
/* Table: PRICING_RULE                                          */
/*==============================================================*/
create table USER_PRICING.PRICING_RULE
(
   PRICING_RULE_ID      numeric(9,0) not null comment '定价判断条件的标识',
   PRICING_SECTION_ID   numeric(9,0) not null comment '该判断条件归属的定价段落',
   PRICING_REF_OBJECT_ID numeric(9,0) not null comment '用于指定判断条件的参考对象，即判断表达式中条件运算符的左侧内容',
   OPERATOR_ID          numeric(9,0) not null comment '如何进行比较，如大于、小于等。即判断表达式中的条件运算符',
   RESULT_REF_VALUE_ID  numeric(9,0) not null comment '与参考对象比较的值，即判断表达式中条件运算符的右侧内容',
   GROUP_ID             numeric(9,0) not null comment '用于实现与、或操作（同组为与，异组为或）',
   primary key (PRICING_RULE_ID)
);

alter table USER_PRICING.PRICING_RULE comment '定价域中用于定义执行某种定价规则中所包含的条件。在定价段落中，引用定价判断条件来确定如何搜索资费标准或优惠计算。';

/*==============================================================*/
/* Index: I_FKK_PRICING_SECTION_22                              */
/*==============================================================*/
create index I_FKK_PRICING_SECTION_22 on USER_PRICING.PRICING_RULE
(
   PRICING_SECTION_ID
);

/*==============================================================*/
/* Index: I_FKK_OPERATOR_23                                     */
/*==============================================================*/
create index I_FKK_OPERATOR_23 on USER_PRICING.PRICING_RULE
(
   OPERATOR_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_24                           */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_24 on USER_PRICING.PRICING_RULE
(
   PRICING_REF_OBJECT_ID
);

/*==============================================================*/
/* Index: I_FKK_REF_VALUE_234                                   */
/*==============================================================*/
create index I_FKK_REF_VALUE_234 on USER_PRICING.PRICING_RULE
(
   RESULT_REF_VALUE_ID
);

/*==============================================================*/
/* Table: PRICING_SECTION                                       */
/*==============================================================*/
create table USER_PRICING.PRICING_SECTION
(
   PRICING_SECTION_ID   numeric(9,0) not null comment '定价段落的标识',
   SECTION_TYPE_ID      numeric(9,0) not null comment '定价段落类型的唯一标识。',
   SECTION_CALC_TYPE    varchar(3) not null comment '说明如何进行分段。',
   PRICING_SECTION_NAME varchar(50) comment '定价段落名称，一般不用。特殊情况下，用于说明本段落的判断意图',
   PARENT_SECTION_ID    numeric(9,0) comment '父标识，用于表达段落的层次树状关系',
   PRICING_REF_OBJECT_ID numeric(9,0) comment '进行段落比较时，如果是引用参考对象类型，则本字段指定引用的参考对象标识',
   ZONE_ITEM_ID         numeric(9,0) comment '当使用区表进行分段时，指明引用哪个区表节点',
   CYCLE_SECTION_BEGIN  numeric(5,0) comment '当定价段落为循环段时，指明循环段的起始值。',
   CYCLE_SECTION_DURATION numeric(5,0) comment '当定价段落为循环段时，指明循环段的间隔。',
   START_REF_VALUE_ID   numeric(9,0) comment '进行段落比较时，用于指明段落取值的起始值。当类型为“引用判断规则”时，本字段指明为真时引用，还是为假时引用',
   END_REF_VALUE_ID     numeric(9,0) comment '进行段落比较时，用于指明段落取值的起始值。当类型为“引用判断规则”时，本字段为空',
   JUDGE_RESULT         varchar(1) not null comment '使本定价段落生效的判断结果。',
   EVENT_PRICING_STRATEGY_ID numeric(9,0) comment '事件定价策略的标识',
   CALC_PRIORITY        numeric(3,0) not null comment '计算的优先级，与段落关系组合表达计算顺序和计算逻辑。小的优先执行',
   primary key (PRICING_SECTION_ID)
);

alter table USER_PRICING.PRICING_SECTION comment '在电信企业制定市场营销计划和运营支撑过程，确定一个特定计费帐务事件的定价因素很多，在定价域模型中通过定义一棵以定价过程为';

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_19                           */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_19 on USER_PRICING.PRICING_SECTION
(
   PRICING_REF_OBJECT_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_SECTION_21                              */
/*==============================================================*/
create index I_FKK_PRICING_SECTION_21 on USER_PRICING.PRICING_SECTION
(
   PARENT_SECTION_ID
);

/*==============================================================*/
/* Index: I_FKK_ZONE_ITEM_35                                    */
/*==============================================================*/
create index I_FKK_ZONE_ITEM_35 on USER_PRICING.PRICING_SECTION
(
   ZONE_ITEM_ID
);

/*==============================================================*/
/* Index: I_FKK_EVENT_PRICING_STRAT_196                         */
/*==============================================================*/
create index I_FKK_EVENT_PRICING_STRAT_196 on USER_PRICING.PRICING_SECTION
(
   EVENT_PRICING_STRATEGY_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_SECTION_TYPE_200                        */
/*==============================================================*/
create index I_FKK_PRICING_SECTION_TYPE_200 on USER_PRICING.PRICING_SECTION
(
   SECTION_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_REF_VALUE_228                                   */
/*==============================================================*/
create index I_FKK_REF_VALUE_228 on USER_PRICING.PRICING_SECTION
(
   END_REF_VALUE_ID
);

/*==============================================================*/
/* Index: I_FKK_REF_VALUE_229                                   */
/*==============================================================*/
create index I_FKK_REF_VALUE_229 on USER_PRICING.PRICING_SECTION
(
   START_REF_VALUE_ID
);

/*==============================================================*/
/* Table: PRICING_SECTION_RELATION                              */
/*==============================================================*/
create table USER_PRICING.PRICING_SECTION_RELATION
(
   A_SECTION_ID         numeric(9,0) not null comment '主段落的标识',
   Z_SECTION_ID         numeric(9,0) not null comment '从段落的标识',
   RELATION_TYPE        varchar(3) not null comment '两个段落之间的关系类型，譬如互斥，关联',
   primary key (A_SECTION_ID, Z_SECTION_ID)
);

alter table USER_PRICING.PRICING_SECTION_RELATION comment '定价段落关系用于描述定价段落之间的关系，如依赖关系、互斥关系等。定价段落关系与定价段落中的计算优先级共同决定当有多个段落';

/*==============================================================*/
/* Index: I_FKK_PRICING_SECTION_44                              */
/*==============================================================*/
create index I_FKK_PRICING_SECTION_44 on USER_PRICING.PRICING_SECTION_RELATION
(
   A_SECTION_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_SECTION_45                              */
/*==============================================================*/
create index I_FKK_PRICING_SECTION_45 on USER_PRICING.PRICING_SECTION_RELATION
(
   Z_SECTION_ID
);

/*==============================================================*/
/* Table: PRICING_SECTION_TYPE                                  */
/*==============================================================*/
create table USER_PRICING.PRICING_SECTION_TYPE
(
   SECTION_TYPE_ID      numeric(9,0) not null comment '定价段落类型的唯一标识。',
   SECTION_TYPE_NAME    varchar(50) not null comment '段落类型的名称。',
   primary key (SECTION_TYPE_ID)
);

alter table USER_PRICING.PRICING_SECTION_TYPE comment '指出定价段落的具体类型，具体列值请参照附录。';

/*==============================================================*/
/* Table: PRIVILEGE                                             */
/*==============================================================*/
create table PARTY_USER.PRIVILEGE
(
   PRIVILEGE_ID         numeric(9,0) not null comment '权限的唯一标识。',
   PARENT_PRIVILEGEID   numeric(9,0) comment '父权限标识用来构造多级菜单，PARENT_ID=''0''时表示第一级菜单。',
   PRIVILEGE_NAME       varchar(50) not null comment '权限名称，应用系统菜单的名称。',
   PRIVILEGE_TYPE       varchar(3) not null comment '使用类型',
   APP_CODE             varchar(3) not null comment '使用类型',
   PRIVILEGE_DESC       varchar(250) not null comment '使用类型',
   primary key (PRIVILEGE_ID)
);

alter table PARTY_USER.PRIVILEGE comment '权限是指电信内部参与人在电信业务活动中的可被赋予的最小权利单位。';

/*==============================================================*/
/* Index: I_FKK_PRIVILEGE_189                                   */
/*==============================================================*/
create index I_FKK_PRIVILEGE_189 on PARTY_USER.PRIVILEGE
(
   PARENT_PRIVILEGEID
);

/*==============================================================*/
/* Table: PRODUCT                                               */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT
(
   PRODUCT_ID           numeric(9,0) not null comment '用于唯一标识产品/服务的内部编号',
   PRODUCT_PROVIDER_ID  numeric(9,0) not null comment '表明产品由哪个产品提供者提供',
   PRICING_PLAN_ID      numeric(9,0) not null comment '定价计划标识',
   INTEGRAL_PRICING_PLAN_ID numeric(9,0) comment '积分计划标识',
   PRODUCT_FAMILY_ID    numeric(9,0) comment '产品家族的唯一标识。',
   PRODUCT_NAME         varchar(50) not null comment '产品名称',
   PRODUCT_COMMENTS     varchar(250) not null comment '产品描述',
   PRODUCT_TYPE         varchar(3) not null comment '描述客户购买此产品时是必须的或选择性的(如增值业务)- Mandatory必须的： 此产品可以单独购买.- Optional可选的：此产品需要依赖其他产品',
   PRODUCT_CLASSIFICATION varchar(3) not null comment '产品类别，表明是主产品还是附属产品',
   PRODUCT_CODE         varchar(15) not null comment '产品的外部标准编码。',
   STATE                varchar(3) not null comment '产品的状态。 标识一个产品当前的状态，包括：a) 作废状态b) 等待批准状态c) 已批准状态 d) 在用状态 e) 失效状态',
   EFF_DATE             datetime not null comment '产品生效的日期',
   EXP_DATE             datetime comment '产品失效的日期，如果有界定的话。 缺省是空白， 表示没有设计好失效日期',
   primary key (PRODUCT_ID)
);

alter table USER_PRODUCT.PRODUCT comment '定义了有明确价格并能够被客户(Customer)购买/租赁的内容 ，分为主产品和附属产品';


/*==============================================================*/
/* Index: I_FKK_PRODUCT_FAMILY_257                              */
/*==============================================================*/
create index I_FKK_PRODUCT_FAMILY_257 on USER_PRODUCT.PRODUCT
(
   PRODUCT_FAMILY_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_PLAN_107                                */
/*==============================================================*/
create index I_FKK_PRICING_PLAN_107 on USER_PRODUCT.PRODUCT
(
   PRICING_PLAN_ID
);

/*==============================================================*/
/* Index: I_FKK_PARTY_ROLE_205                                  */
/*==============================================================*/
create index I_FKK_PARTY_ROLE_205 on USER_PRODUCT.PRODUCT
(
   PRODUCT_PROVIDER_ID
);

/*==============================================================*/
/* Table: PRODUCT_ATTR                                          */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_ATTR
(
   ATTR_SEQ             numeric(9,0) not null comment '产品属性的唯一标识。',
   PRODUCT_ID           numeric(9,0) not null comment '产品标识',
   ATTR_VALUE_TYPE_ID   numeric(9,0) not null comment '属性值类型的唯一标识。',
   ATTR_VALUE_UNIT_ID   numeric(9,0) not null comment '属性值单位的唯一标识。',
   ATTR_CHARACTER       varchar(250) not null comment '产品属性特征的文字描述',
   ATTR_VALUE           varchar(30) not null comment '产品属性特征的值，例如ADSL的带宽值，当属性值类型为联系型整数时，用M，N表示最大值最小值范围',
   ALLOW_CUSTOMIZED_FLAG varchar(1) comment '标志着是否允许自定义产品的属性',
   IF_DEFAULT_VALUE     varchar(1) comment '定义产品的属性是否为产品的缺省属性,以减少服务实例信息表服务实例确定的具体的属性的数量，如果产品具有缺省属性，在服务实例中无需再记录',
   primary key (ATTR_SEQ)
);

alter table USER_PRODUCT.PRODUCT_ATTR comment '产品属性（Product Attribute）定义了产品初基本信息外的动态信息，重点强调“动态”属性，所有可以动态配置的';


/*==============================================================*/
/* Index: I_FKK_PRODUCT_1                                       */
/*==============================================================*/
create index I_FKK_PRODUCT_1 on USER_PRODUCT.PRODUCT_ATTR
(
   PRODUCT_ID
);

/*==============================================================*/
/* Index: I_FKK_ATTR_VALUE_TYPE_210                             */
/*==============================================================*/
create index I_FKK_ATTR_VALUE_TYPE_210 on USER_PRODUCT.PRODUCT_ATTR
(
   ATTR_VALUE_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_ATTR_VALUE_UNIT_212                             */
/*==============================================================*/
create index I_FKK_ATTR_VALUE_UNIT_212 on USER_PRODUCT.PRODUCT_ATTR
(
   ATTR_VALUE_UNIT_ID
);

/*==============================================================*/
/* Table: PRODUCT_FAMILY                                        */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_FAMILY
(
   PRODUCT_FAMILY_ID    numeric(9,0) not null comment '产品家族的唯一标识。',
   PRODUCT_FAMILY_NAME  varchar(50) not null comment '产品家族的名称。',
   PRODUCT_FAMILY_DESC  varchar(4000) not null comment '存储产品家族的详细描述。',
   primary key (PRODUCT_FAMILY_ID)
);

alter table USER_PRODUCT.PRODUCT_FAMILY comment '多种类似产品组成产品家族。不同产品家族的业务号码可能相同，所以需要通过产品家族标识进行区分。';

/*==============================================================*/
/* Table: PRODUCT_OFFER                                         */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER
(
   OFFER_ID             numeric(9,0) not null comment '销售品的唯一标识。',
   BAND_ID              numeric(9,0) comment '品牌的唯一标识',
   PRICING_PLAN_ID      numeric(9,0) comment '定价计划标识',
   INTEGRAL_PRICING_PLAN_ID numeric(9,0) comment '积分计划标识',
   OFFER_NAME           varchar(50) not null comment '销售品的中文名称。',
   OFFER_COMMENTS       varchar(250) not null comment '销售品的详细描述。',
   CAN_BE_BUY_ALONE     varchar(1) not null comment '本销售品是否可以被单独购买。',
   OFFER_CODE           varchar(15) not null comment '销售品的外部标准编码。',
   PRIORITY             numeric(3,0) not null comment '优先级',
   STATE                varchar(3) not null comment '销售品的状态。',
   EFF_DATE             datetime not null comment '销售品的生效时间',
   EXP_DATE             datetime comment '销售品的失效日期，如果有界定的话。 缺省是空白， 表示没有失效日期。',
   primary key (OFFER_ID)
);

alter table USER_PRODUCT.PRODUCT_OFFER comment '销售品(Product Offer) 业务实体域从市场销售的角度对产品/服务、定价方案的其中一项或者多项内容进行的重新包';


/*==============================================================*/
/* Index: I_FKK_BAND_254                                        */
/*==============================================================*/
create index I_FKK_BAND_254 on USER_PRODUCT.PRODUCT_OFFER
(
   BAND_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_PLAN_273                                */
/*==============================================================*/
create index I_FKK_PRICING_PLAN_273 on USER_PRODUCT.PRODUCT_OFFER
(
   PRICING_PLAN_ID
);

/*==============================================================*/
/* Table: PRODUCT_OFFER_ATTR                                    */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER_ATTR
(
   OFFER_ATTR_SEQ       numeric(9,0) not null comment '销售品元素属性编号，与元素标识一起用来唯一识别销售品中一项元素的动态属性',
   OFFER_ID             numeric(9,0) not null comment '销售品的唯一标识。',
   ATTR_VALUE_TYPE_ID   numeric(9,0) not null comment '属性值类型的唯一标识。',
   ATTR_VALUE_UNIT_ID   numeric(9,0) not null comment '属性值单位的唯一标识。',
   OFFER_ATTR_CHARACTER varchar(50) not null comment '构成销售品的元素属性特征的文字描述',
   OFFER_ATTR_VALUE     varchar(30) not null comment '构成销售品的元素属性特征的值，当属性值类型为联系型整数时，用M，N表示最大值最小值范围',
   ALLOW_CUSTOMIZED_FLAG varchar(1) not null comment '注明此项销售品元素的属性是否允许客户进行定制',
   EXCLUABLITY          varchar(1) not null comment '对构成销售品的元素属性特征的值，是包含关系还是排除关系',
   IF_DEFAULT_VALUE     varchar(1) not null comment '对构成销售品的元素属性特征的值，是否采用缺省值',
   ELEMENT_TYPE         varchar(3) not null comment '构成销售品的元素的类别，可以为：产品、定价计划',
   ELEMENT_ID           numeric(12,0) not null comment '销售品包含的具体元素的标识，如果是产品则为Product_ID，如果是定价计划则为priceplan_ID',
   primary key (OFFER_ATTR_SEQ)
);

alter table USER_PRODUCT.PRODUCT_OFFER_ATTR comment '用于描述销售品的属性，销售品属性可以是销售品独立的属性，比如同类销售品的不同套餐类型，也可以是销售品包含的产品的属性，
';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_14                                */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_14 on USER_PRODUCT.PRODUCT_OFFER_ATTR
(
   OFFER_ID
);

/*==============================================================*/
/* Index: I_FKK_ATTR_VALUE_TYPE_211                             */
/*==============================================================*/
create index I_FKK_ATTR_VALUE_TYPE_211 on USER_PRODUCT.PRODUCT_OFFER_ATTR
(
   ATTR_VALUE_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_ATTR_VALUE_UNIT_213                             */
/*==============================================================*/
create index I_FKK_ATTR_VALUE_UNIT_213 on USER_PRODUCT.PRODUCT_OFFER_ATTR
(
   ATTR_VALUE_UNIT_ID
);

/*==============================================================*/
/* Table: PRODUCT_OFFER_INSTANCE                                */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER_INSTANCE
(
   PRODUCT_OFFER_INSTANCE_ID numeric(12,0) not null comment '销售品实例的唯一表示。',
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   CUST_AGREEMENT_ID    numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   OFFER_ID             numeric(9,0) not null comment '销售品的唯一标识。',
   EFF_DATE             datetime not null comment '本客户开始使用电信产品的时间',
   STATE                varchar(3) not null comment '销售品实例的状态。',
   STATE_DATE           datetime not null comment '销售品实例状态变更的时间。',
   PRIORITY             numeric(3,0) comment '销售品实例优先级，不作为强制要求',
   primary key (PRODUCT_OFFER_INSTANCE_ID)
);

alter table USER_PRODUCT.PRODUCT_OFFER_INSTANCE comment '客户可以通过一定的服务提供方式订购电信产品，使用的电信提供的业务，一旦产品，销售品被客户购买，一个销售品实例就形成了，也';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_272                               */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_272 on USER_PRODUCT.PRODUCT_OFFER_INSTANCE
(
   OFFER_ID
);

/*==============================================================*/
/* Index: I_FKK_CUST_197                                        */
/*==============================================================*/
create index I_FKK_CUST_197 on USER_PRODUCT.PRODUCT_OFFER_INSTANCE
(
   CUST_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_198                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_198 on USER_PRODUCT.PRODUCT_OFFER_INSTANCE
(
   CUST_AGREEMENT_ID
);

/*==============================================================*/
/* Table: PRODUCT_OFFER_INSTANCE_ATTR                           */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER_INSTANCE_ATTR
(
   SERV_ID              numeric(12,0) not null comment '销售品实例的唯一表示。',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   ATTR_ID              numeric(9,0) not null comment '销售品属性的唯一标识。',
   ATTR_VAL             varchar(30) not null comment '产品实例附加属性的内容',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SERV_ID, AGREEMENT_ID, ATTR_ID)
);

alter table USER_PRODUCT.PRODUCT_OFFER_INSTANCE_ATTR comment '本实体描述了销售品实例的一些附加信息，便于描述销售品实例的一些个性化特征。';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_INSTA_214                         */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_INSTA_214 on USER_PRODUCT.PRODUCT_OFFER_INSTANCE_ATTR
(
   SERV_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_215                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_215 on USER_PRODUCT.PRODUCT_OFFER_INSTANCE_ATTR
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_ATTR_216                          */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_ATTR_216 on USER_PRODUCT.PRODUCT_OFFER_INSTANCE_ATTR
(
   ATTR_ID
);

/*==============================================================*/
/* Table: PRODUCT_OFFER_OBJECT                                  */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER_OBJECT
(
   OFFER_OBJECT_ID      numeric(9,0) not null comment '包含对象的标识',
   OFFER_ID             numeric(9,0) not null comment '销售品的唯一标识。',
   OBJECT_TYPE          varchar(3) not null comment '对象类型',
   OBJECT_AMOUNT_START  numeric(8,0) not null comment '限制该对象数量的上限，为空表示不限定上限。',
   OBJECT_AMOUNT_END    numeric(8,0) not null comment '限制该对象数量的下限，为空表示不限定下限。',
   OBJECT_ID            numeric(9,0) not null comment '销售品包含对象在受理时的先后顺序',
   primary key (OFFER_OBJECT_ID)
);

alter table USER_PRODUCT.PRODUCT_OFFER_OBJECT comment '销售品定价时有关的各种数据对象，可以是产品、销售品、客户、账户、帐本、累积量等.';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_252                               */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_252 on USER_PRODUCT.PRODUCT_OFFER_OBJECT
(
   OFFER_ID
);

/*==============================================================*/
/* Table: PRODUCT_OFFER_OBJECT_INSTANCE                         */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER_OBJECT_INSTANCE
(
   OFFER_OBJECT_INSTANCE_ID numeric(12,0) not null comment '包含对象实例标识',
   PRODUCT_OFFER_INSTANCE_ID numeric(12,0) not null comment '销售品实例的唯一表示。',
   OFFER_OBJECT_ID      numeric(9,0) comment '包含对象的标识',
   OBJECT_TYPE          varchar(3) not null comment '销售品实例包含的对象类型',
   OBJECT_ID            numeric(12,0) not null comment '销售品实例包含的对象的对象标识',
   STATE                varchar(3) not null comment '本记录的状态。',
   EFF_DATE             datetime not null comment '本记录的生效时间。',
   EXP_DATE             datetime comment '本记录的失效时间。',
   primary key (OFFER_OBJECT_INSTANCE_ID)
);

alter table USER_PRODUCT.PRODUCT_OFFER_OBJECT_INSTANCE comment '销售品实例包含的对象实例';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_INSTA_259                         */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_INSTA_259 on USER_PRODUCT.PRODUCT_OFFER_OBJECT_INSTANCE
(
   PRODUCT_OFFER_INSTANCE_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_OBJECT_268                        */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_OBJECT_268 on USER_PRODUCT.PRODUCT_OFFER_OBJECT_INSTANCE
(
   OFFER_OBJECT_ID
);

/*==============================================================*/
/* Table: PRODUCT_OFFER_PARAM                                   */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER_PARAM
(
   OFFER_PARAM_ID       numeric(9,0) not null comment '主键唯一标识',
   OFFER_ID             numeric(9,0) not null comment '销售品的唯一标识。',
   PARAM_ATTR_ID        numeric(9,0) not null comment '参数属性标识',
   PARAM_NAME           varchar(50) not null comment '参数名称
            ',
   DEFAULT_VALUE        varchar(30) not null comment '参数缺省值',
   primary key (OFFER_PARAM_ID)
);

alter table USER_PRODUCT.PRODUCT_OFFER_PARAM comment '销售品定价时需要的定价参数。';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_253                               */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_253 on USER_PRODUCT.PRODUCT_OFFER_PARAM
(
   OFFER_ID
);

/*==============================================================*/
/* Table: PRODUCT_OFFER_PARAM_INSTANCE                          */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER_PARAM_INSTANCE
(
   OFFER_PARAM_INSTANCE_ID numeric(9,0) not null comment '参数取值唯一标识',
   PRODUCT_OFFER_INSTANCE_ID numeric(12,0) not null comment '销售品实例的唯一表示。',
   LIFE_CYCLE_ID        numeric(9,0) not null comment '生命周期的标识',
   OFFER_PARAM_ID       numeric(9,0) not null comment '销售品参数标识，用于关联销售品参数实体',
   OFFER_OBJECT_INSTANCE_ID numeric(12,0) comment '包含对象实例标识',
   PARAM_VALUE          varchar(30) not null comment '参数取值',
   PARAM_ATTR_ID        varchar(30) not null comment '销售品参数统一编码属性标识，用于唯一标识一个参数。',
   primary key (OFFER_PARAM_INSTANCE_ID)
);

alter table USER_PRODUCT.PRODUCT_OFFER_PARAM_INSTANCE comment '销售品实例的参数取值';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_INSTA_260                         */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_INSTA_260 on USER_PRODUCT.PRODUCT_OFFER_PARAM_INSTANCE
(
   PRODUCT_OFFER_INSTANCE_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_PARAM_269                         */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_PARAM_269 on USER_PRODUCT.PRODUCT_OFFER_PARAM_INSTANCE
(
   OFFER_PARAM_ID
);

/*==============================================================*/
/* Index: I_FKK_LIFE_CYCLE_266                                  */
/*==============================================================*/
create index I_FKK_LIFE_CYCLE_266 on USER_PRODUCT.PRODUCT_OFFER_PARAM_INSTANCE
(
   LIFE_CYCLE_ID
);

/*==============================================================*/
/* Table: PRODUCT_OFFER_RELATION                                */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER_RELATION
(
   RELATION_ID          numeric(9,0) not null comment '唯一标识两个销售品间的关系',
   OFFER_A_ID           numeric(9,0) not null comment '原始销售品标识',
   OFFER_Z_ID           numeric(9,0) not null comment '目标销售品标识',
   RELATION_TYPE_ID     varchar(3) comment '原始销售品和目标销售品间的关系类型，例如：依赖关系、互斥关系、提升销售关系等等',
   OPTIONAL_OFFER       varchar(1) not null comment '本销售品是否是可选销售品.',
   OPERATION_FLAG       varchar(3) not null comment '定义了违反关系种类中定义的规则的行为。 例如：受理两种竞争的产品时系统的反应。',
   EFF_DATE             datetime not null comment '销售品关系的生效日期和时间',
   EXP_DATE             datetime comment '销售品关系的失效日期和时间',
   primary key (RELATION_ID)
);

alter table USER_PRODUCT.PRODUCT_OFFER_RELATION comment '定义销售品间的关系';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_9                                 */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_9 on USER_PRODUCT.PRODUCT_OFFER_RELATION
(
   OFFER_A_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_10                                */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_10 on USER_PRODUCT.PRODUCT_OFFER_RELATION
(
   OFFER_Z_ID
);

/*==============================================================*/
/* Table: PRODUCT_OFFER_RESTRICATION                            */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_OFFER_RESTRICATION
(
   RESTRICATION_SEQ     numeric(9,0) not null comment '销售品限制因素的记录序列号',
   OFFER_ID             numeric(9,0) not null comment '销售品的唯一标识。',
   STRATEGY_ID          numeric(9,0) not null comment '市场策略的唯一记录标识',
   RESTRICATION_DOMAIN_TYPE varchar(3) not null comment '说明限制因素是客户群、帐户群、渠道还是地域类型Restrication_Domain_Type 01-Customer Segment 02-ACCT Segment 03-Location Segment 04-Distribute Channel Segmet',
   RESTRICATION_DOMAIN_ID numeric(12,0) not null comment '限制因素中客户群、帐户群、渠道、地域的唯一标识',
   primary key (RESTRICATION_SEQ)
);

alter table USER_PRODUCT.PRODUCT_OFFER_RESTRICATION comment '记录了销售品的限制条件，限制域类型属性体现销售品的不同类型的限制条件，如客户群，帐户群，地域，时间限制等';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_OFFER_12                                */
/*==============================================================*/
create index I_FKK_PRODUCT_OFFER_12 on USER_PRODUCT.PRODUCT_OFFER_RESTRICATION
(
   OFFER_ID
);

/*==============================================================*/
/* Index: I_FKK_MAKET_STRATEGY_13                               */
/*==============================================================*/
create index I_FKK_MAKET_STRATEGY_13 on USER_PRODUCT.PRODUCT_OFFER_RESTRICATION
(
   STRATEGY_ID
);

/*==============================================================*/
/* Table: PRODUCT_RELATION                                      */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_RELATION
(
   RELATION_ID          numeric(9,0) not null comment '用于唯一标识一个产品关系内部编号',
   PROD_A_ID         numeric(9,0) not null comment '处于此关系A 端下的产品一的ID',
   PROD_Z_ID            numeric(9,0) not null comment '处于此关系Z 端下的产品二的ID',
   PROD_A_PROVIDER_ID   numeric(9,0) not null comment '处于此关系A 端下的产品一的提供者，用以区别产品关系是内部产品之间的关系还是内部产品和外部产品的关系，还是外部产品间的关系',
   PROD_Z_PROVIDER_ID   numeric(9,0) not null comment '处于此关系Z 端下的产品一的提供者，用以区别产品关系是内部产品之间的关系还是内部产品和外部产品的关系，还是外部产品间的关系',
   RELATION_TYPE_ID     numeric(9,0) not null comment '关系的类型',
   OPERATION_FLAG       varchar(3) not null comment '定义了违反关系种类中定义的规则的行为。 例如：受理两种互斥的产品时系统的反应',
   EFF_DATE             datetime not null comment '关系的生效日期和时间',
   EXP_DATE             datetime comment '关系的失效日期和时间',
   primary key (RELATION_ID)
);

alter table USER_PRODUCT.PRODUCT_RELATION comment '定义电信内部产品间的关系，以及电信产品和外部产品间的关系。';



/*==============================================================*/
/* Index: I_FKK_PRODUCT_2                                       */
/*==============================================================*/
create index I_FKK_PRODUCT_2 on USER_PRODUCT.PRODUCT_RELATION
(
   PROD_A_ID
);

/*==============================================================*/
/* Index: I_FKK_EXTERNAL_PRODUCT_3                              */
/*==============================================================*/
create index I_FKK_EXTERNAL_PRODUCT_3 on USER_PRODUCT.PRODUCT_RELATION
(
   PROD_Z_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_RELATION_TYPE_4                         */
/*==============================================================*/
create index I_FKK_PRODUCT_RELATION_TYPE_4 on USER_PRODUCT.PRODUCT_RELATION
(
   RELATION_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_PARTY_ROLE_202                                  */
/*==============================================================*/
create index I_FKK_PARTY_ROLE_202 on USER_PRODUCT.PRODUCT_RELATION
(
   PROD_A_PROVIDER_ID
);

/*==============================================================*/
/* Index: I_FKK_PARTY_ROLE_204                                  */
/*==============================================================*/
create index I_FKK_PARTY_ROLE_204 on USER_PRODUCT.PRODUCT_RELATION
(
   PROD_Z_PROVIDER_ID
);

/*==============================================================*/
/* Table: PRODUCT_RELATION_TYPE                                 */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_RELATION_TYPE
(
   RELATION_TYPE_ID     numeric(9,0) not null comment '用于唯一标识一个关系类型',
   RELATION_TYPE_NAME   varchar(50) not null comment '关系类型名称，当Relation_Type_Domain 表示是内部产品间关系时，可以是“互斥关系”、“依赖关系”， “打包关系”，当Relation_Type_Domain 表示是与外部产品间关系时时可以是“竞争关系”或者是“替代关系”，用户可以根据需要扩充关系类型
            -“互斥关系”意味着两种产品，不应该同时在一个服务实例中存在。
            -“依赖关系 ”意味着一个产品依靠另外一个在相同的服务实例中已被受理的产品
            - “打包关系”意味着两种产品是位于同一个产品包内 
            -“竞争关系”意味着两种产品是相互竞争的。
            -“替代关系 ”意味着一个产品 可以被另外一个在相同的服务实例中的产品替代
            
            ',
   RELATION_TYPE_DESC   varchar(250) not null comment '关系类型的详细描述',
   RELATION_TYPE_DOMAIN varchar(3) comment '关系类型是内部产品关系还是外部产品关系
            －0.内部产品关系
            －1.外部产品关系
            ',
   primary key (RELATION_TYPE_ID)
);

alter table USER_PRODUCT.PRODUCT_RELATION_TYPE comment '定义产品间的关系的类型，供产品关系表引用。包括依赖关系、互斥关系、停机连带关系等。其中的停机连带关系可以用于表达当某些附';

/*==============================================================*/
/* Table: PRODUCT_RESOURCE                                      */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_RESOURCE
(
   RESOURCE_TYPE_ID     numeric(9,0) not null comment '用于唯一标识产品资源类型的编号，产品资源类型描述服务实例占用电信的资源信息，这里我们只关心用户的接入终端，例如一部普通电话，一部小灵通电话',
   PRODUCT_ID           numeric(9,0) not null comment '用于唯一标识产品的编号',
   RESOURCE_TYPE_NAME   varchar(50) not null comment '用于命名产品资源类型',
   EFF_DATE             datetime not null comment '用于记录产品资源生效时间',
   EXP_DATE             datetime comment '用于记录产品资源失效时间',
   primary key (RESOURCE_TYPE_ID)
);

alter table USER_PRODUCT.PRODUCT_RESOURCE comment '产品资源描述业务占用电信的资源信息，这里我们只关心用户的接入终端，例如一部普通电话，一部小灵通电话。';


/*==============================================================*/
/* Index: I_FKK_PRODUCT_8                                       */
/*==============================================================*/
create index I_FKK_PRODUCT_8 on USER_PRODUCT.PRODUCT_RESOURCE
(
   PRODUCT_ID
);

/*==============================================================*/
/* Table: PRODUCT_USAGE_EVENT_TYPE                              */
/*==============================================================*/
create table USER_PRODUCT.PRODUCT_USAGE_EVENT_TYPE
(
   PRODUCT_ID           numeric(9,0) not null comment '用于唯一标识产品类型的内部编号',
   EVENT_TYPE_ID        numeric(9,0) not null comment '计费帐务事件类型的唯一标识。',
   EFF_DATE             datetime not null comment '计费事件类型的生效时间',
   EXP_DATE             numeric(12,0) comment '计费事件类型的失效日期，如果有界定的话。 缺省是空白， 表示没有失效日期。',
   primary key (PRODUCT_ID, EVENT_TYPE_ID)
);

alter table USER_PRODUCT.PRODUCT_USAGE_EVENT_TYPE comment '描述产品和计费事件类型之间的关联关系，计费事件由主产品产生，但是主产品和附属产品都可以关联计费事件类型，比如固定电话语音';

/*==============================================================*/
/* Index: I_FKK_DEST_EVENT_TYPE_322                             */
/*==============================================================*/
create index I_FKK_DEST_EVENT_TYPE_322 on USER_PRODUCT.PRODUCT_USAGE_EVENT_TYPE
(
   EVENT_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_5                                       */
/*==============================================================*/
create index I_FKK_PRODUCT_5 on USER_PRODUCT.PRODUCT_USAGE_EVENT_TYPE
(
   PRODUCT_ID
);

/*==============================================================*/
/* Table: PROVIDED_CAPABILITY_INFO                              */
/*==============================================================*/
create table PROVIDED_CAPABILITY_INFO
(
   PROVIDED_CAPABILITY_ID numeric(9,0) not null comment '能力提供标识',
   CAPABILITY_ID        numeric(9,0) not null comment '能力标识
            ',
   CAPABILITY_TYPE      varchar(20) not null comment '能力发布的类型，包括public，private',
   REGISTERED_DATE      datetime not null comment '能力登记的日期',
   IP_ADD               varchar(20) not null comment 'IP地址
            ',
   PORT                 varchar(20) not null comment '端口号',
   NODE_ID              numeric(9,0) not null comment '网元标识
            ',
   STATE                varchar(20) not null comment '能力的状态。包括登记、激活、去激活、注销',
   STATE_DATE           datetime not null comment '当前状态开始的日期',
   primary key (PROVIDED_CAPABILITY_ID)
);

alter table PROVIDED_CAPABILITY_INFO comment '本网元所能提供能力的集合';

/*==============================================================*/
/* Table: RATABLE_CYCLE                                         */
/*==============================================================*/
create table USER_ACCT.RATABLE_CYCLE
(
   RATABLE_CYCLE_ID     numeric(9,0) not null comment '累计周期标识',
   RATABLE_CYCLE_TYPE_ID numeric(9,0) comment '累计周期类别的标识。',
   CYCLE_BEGIN_DATE     datetime not null comment '本帐务周期开始的时间。',
   CYCLE_END_DATE       datetime not null comment '本帐务周期截止的时间。',
   STATE                varchar(3) not null comment '帐务周期的状态。',
   STATE_DATE           datetime not null comment '帐务周期状态变更的时间。',
   primary key (RATABLE_CYCLE_ID)
);

alter table USER_ACCT.RATABLE_CYCLE comment '定义累计周期的具体周期信息';

/*==============================================================*/
/* Index: I_FKK_RATABLE_CYCLE_TYPE_299                          */
/*==============================================================*/
create index I_FKK_RATABLE_CYCLE_TYPE_299 on USER_ACCT.RATABLE_CYCLE
(
   RATABLE_CYCLE_TYPE_ID
);

/*==============================================================*/
/* Table: RATABLE_CYCLE_TYPE                                    */
/*==============================================================*/
create table USER_ACCT.RATABLE_CYCLE_TYPE
(
   RATABLE_CYCLE_TYPE_ID numeric(9,0) not null comment '累计周期类别的标识。',
   RATABLE_CYCLE_TYPE_NAME varchar(50) not null comment '累计周期类型的名称。',
   CYCLE_UNIT           varchar(3) not null comment '帐务周期类型对应的周期单位。',
   UNIT_COUNT           numeric(5,0) not null comment '标准编码',
   CYCLE_DURATION       numeric(5,0) not null comment '根据单位间隔设定的偏移量，即帐务周期从哪个单位开始。',
   CYCLE_DURATION_DAYS  numeric(5,0) not null comment '偏移天数，即帐务周期的开始日期。',
   OFFSET_TIME          numeric(12,0) not null comment '周期开始的偏移时间，以秒为单位',
   primary key (RATABLE_CYCLE_TYPE_ID));

alter table USER_ACCT.RATABLE_CYCLE_TYPE comment '定义累计周期的类型，累计周期可能是从某一个具体的时间开始，不能简单的用天为单位';

/*==============================================================*/
/* Table: RATABLE_RESOURCE                                      */
/*==============================================================*/
create table USER_PRICING.RATABLE_RESOURCE
(
   RATABLE_RESOURCE_ID  numeric(9,0) not null comment '积量类型的标识',
   RATABLE_RESOURCE_NAME varchar(50) not null comment '积量类型的名称',
   ORG_TARIFF_UNIT_ID   numeric(9,0) not null comment '表明是基于哪种资费单位包装而成的',
   DEFAULT_RATABLE_CYCLE_TYPE_ID numeric(9,0) comment '累计周期类别的标识。',
   CAN_BE_NEGATIVE      varchar(1) not null comment '该积量类型是否可以为负，一般不能为负，即对其做减操作时，不能将其减小为负数。这样剩余的度量值可以用于其他资费标准',
   DURATIVE_TYPE        varchar(3) not null comment '该积量类型何时有效，如本帐期有效，则本帐期结束后，要将其清零',
   primary key (RATABLE_RESOURCE_ID)
);

alter table USER_PRICING.RATABLE_RESOURCE comment '积量是计费帐务事件的一个累计型对象，可用于保留电信计费中需要跟踪的任何累计变量，如月免费分钟数、下载总字节数等，都可以作';

/*==============================================================*/
/* Index: I_FKK_TARIFF_UNIT_31                                  */
/*==============================================================*/
create index I_FKK_TARIFF_UNIT_31 on USER_PRICING.RATABLE_RESOURCE
(
   ORG_TARIFF_UNIT_ID
);

/*==============================================================*/
/* Table: RATABLE_RESOURCE_ACCUMULATOR                          */
/*==============================================================*/

create table USER_ACCT.RATABLE_RESOURCE_ACCUMULATOR
(
   RATABLE_RESOURCE_ID  numeric(9,0) not null comment '唯一标识一种积量类型, 表示可以作为计费依据的标识，譬如时长、流量、余额、累计消费等。',
   OWNER_TYPE           varchar(3) not null comment '用于标识计费累计值的属主类型：产品实例、帐户、客户',
   OWNER_ID             numeric(12,0) not null comment '用于标识积量具体归属的对象，可以是产品实例、帐户实例、客户实例等。',
   RATABLE_CYCLE_ID     numeric(9,0) comment '累计周期标识',
   BALANCE              numeric(8,0) not null comment '积量的余额信息，可正可负，余额的增减受定价计划和计费处理过程的影响。',
   primary key (RATABLE_RESOURCE_ID, OWNER_TYPE, OWNER_ID)
);

alter table USER_ACCT.RATABLE_RESOURCE_ACCUMULATOR comment '计费累计值（ratable resource accumulator）定义了计费处理过程中生成的可被单个计费事件使用的积';

/*==============================================================*/
/* Index: I_FKK_RATABLE_RESOURCE_236                            */
/*==============================================================*/
create index I_FKK_RATABLE_RESOURCE_236 on USER_ACCT.RATABLE_RESOURCE_ACCUMULATOR
(
   RATABLE_RESOURCE_ID
);

/*==============================================================*/
/* Index: I_FKK_RATABLE_CYCLE_298                               */
/*==============================================================*/
create index I_FKK_RATABLE_CYCLE_298 on USER_ACCT.RATABLE_RESOURCE_ACCUMULATOR
(
   RATABLE_CYCLE_ID
);

/*==============================================================*/
/* Table: RATED_EVENT                                           */
/*==============================================================*/
create table USER_EVENT.RATED_EVENT
(
   RATABLE_EVENT_ID     numeric(12,0) not null comment '计费事件的唯一标识。',
   EVENT_ID             numeric(12,0) not null comment '源事件标识，标识计费帐务事件的源事件',
   EVENT_TYPE_ID        numeric(9,0) not null comment '计费帐务事件类型的唯一标识。',
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   EVENT_CONTENT_ID     numeric(12,0) not null comment '事件内容位置的唯一标识，由该位置标识找出事件内容具体位置',
   primary key (RATABLE_EVENT_ID)
);

alter table USER_EVENT.RATED_EVENT comment '批价后计费事件（rated event）是在计费批价处理阶段，对预处理后事件（pre-processed event）进';

/*==============================================================*/
/* Index: I_FKK_EVENT_CONTENT_INDEX_304                         */
/*==============================================================*/
create index I_FKK_EVENT_CONTENT_INDEX_304 on USER_EVENT.RATED_EVENT
(
   EVENT_CONTENT_ID
);

/*==============================================================*/
/* Index: I_FKK_DEST_EVENT_TYPE_308                             */
/*==============================================================*/
create index I_FKK_DEST_EVENT_TYPE_308 on USER_EVENT.RATED_EVENT
(
   EVENT_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_SOURCE_EVENT_310                                */
/*==============================================================*/
create index I_FKK_SOURCE_EVENT_310 on USER_EVENT.RATED_EVENT
(
   EVENT_ID
);

/*==============================================================*/
/* Index: I_FKK_SERV_323                                        */
/*==============================================================*/
create index I_FKK_SERV_323 on USER_EVENT.RATED_EVENT
(
   SERV_ID
);

/*==============================================================*/
/* Table: REF_VALUE                                             */
/*==============================================================*/

create table USER_PRICING.REF_VALUE
(
   REF_VALUE_ID         numeric(9,0) not null comment '参考值定义的标识',
   REF_VALUE_TYPE       varchar(3) not null comment '参考值类型: 引用数值,引用定价参考对象,引用参数,为空等',
   VALUE_TYPE           varchar(3) not null comment '数值类型: 浮点数,整数,字符串型,布尔型,日期型等',
   PRICING_REF_OBJECT_ID numeric(9,0) comment '若参考值类型是引用定价参考对象，该项有效，表示引用定价参考对象标识，外键，引用PRICING_REF_OBJECT表主键',
   VALUE_STRING         varchar(30) comment '若参考值类型是引用数值，该项有效，表示被引用的数值串',
   PRICING_PRARM_ID     numeric(9,0) comment '若参考值类型是引用参数，该项有效，表示定价参数, 外键，引用PRICING_PARAM表主键',
   RATE_PRECISION       numeric(5,0) not null comment '费率单位的精度',
   CALC_PRECISION       numeric(5,0) not null comment '最终计算结果的精度',
   primary key (REF_VALUE_ID)
);

alter table USER_PRICING.REF_VALUE comment '用于确定进行资费计算或者优惠计算所涉及的具体参考值，它既可以是预先设定的固定值、参数，也可以是定价参考对象的取值。';

/*==============================================================*/
/* Index: I_FKK_PRICING_PARAM_DEFINE_233                        */
/*==============================================================*/
create index I_FKK_PRICING_PARAM_DEFINE_233 on USER_PRICING.REF_VALUE
(
   PRICING_PRARM_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_235                          */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_235 on USER_PRICING.REF_VALUE
(
   PRICING_REF_OBJECT_ID
);

/*==============================================================*/
/* Table: REGION                                                */
/*==============================================================*/
create table USER_LOCATION.REGION
(
   REGION_ID            numeric(9,0) not null comment '唯一标识区域的编号',
   REGION_NAME          varchar(50) not null comment '区域的名称，如本地网名称等',
   REGION_DESC          varchar(250) not null comment '标准地域的描述',
   REGION_CODE          varchar(15) not null,
   primary key (REGION_ID)
);

alter table USER_LOCATION.REGION comment '地理地域有两种划分方式：一种是按照行政区域层次来划分；第二种是按照电信管理区域来划分（包括计费管理区域、统计区域、设备覆';

/*==============================================================*/
/* Table: ROLE                                                  */
/*==============================================================*/
create table PARTY_USER.ROLE
(
   ROLE_ID              numeric(9,0) not null comment '权限组的唯一标识。',
   ROLE_NAME            varchar(50) comment '权限组名称',
   ROLE_DESC            varchar(250) comment '描述权限组的构成及其用法',
   primary key (ROLE_ID)
);

alter table PARTY_USER.ROLE comment '权限组是权限的组合。';

/*==============================================================*/
/* Table: ROLE_PRIVILEGE                                        */
/*==============================================================*/
create table PARTY_USER.ROLE_PRIVILEGE
(
   PRIVILEGE_ID         numeric(9,0) not null comment '权限的唯一标识。',
   ROLE_ID              numeric(9,0) not null comment '权限组的唯一标识。',
   primary key (PRIVILEGE_ID, ROLE_ID)
);

alter table PARTY_USER.ROLE_PRIVILEGE comment '定义权限组具体的权限。';

/*==============================================================*/
/* Index: I_FKK_PRIVILEGE_194                                   */
/*==============================================================*/
create index I_FKK_PRIVILEGE_194 on PARTY_USER.ROLE_PRIVILEGE
(
   PRIVILEGE_ID
);

/*==============================================================*/
/* Index: I_FKK_ROLE_195                                        */
/*==============================================================*/
create index I_FKK_ROLE_195 on PARTY_USER.ROLE_PRIVILEGE
(
   ROLE_ID
);

/*==============================================================*/
/* Table: SC_INFO                                               */
/*==============================================================*/
create table SC_INFO
(
   SC_ID                numeric(9,0) not null comment 'SC标识',
   SC_CODE              varchar(15) not null comment 'SC唯一编码',
   SC_NAME              varchar(50) comment 'SC名称',
   IP_ADD               varchar(20) not null comment 'IP地址',
   PORT                 varchar(20) not null comment '端口号',
   STATE                varchar(20) not null comment 'LSC的状态。包括登记、激活、去激活、注销',
   STATE_DATE           datetime not null comment '当前状态开始的日期',
   primary key (SC_ID)
);

alter table SC_INFO comment '描述业务控制器(Service Controller )的基本信息，SC负责全集团内服务能力管理及其路由查询。';

/*==============================================================*/
/* Table: SERV                                                  */
/*==============================================================*/

create table USER_PRODUCT.SERV
(
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   CUST_ID              numeric(12,0) not null comment '帐户所属的客户唯一标识',
   PRODUCT_ID           numeric(9,0) not null comment '用于唯一标识产品/服务的内部编号',
   BILLING_CYCLE_TYPE_ID numeric(9,0) comment '帐务周期类别的标识。',
   PRODUCT_FAMILY_ID    numeric(9,0) comment '产品家族的唯一标识。',
   CREATE_DATE          datetime not null comment '本客户开始使用电信产品的时间',
   RENT_DATE            datetime comment '起租日期',
   COMPLETED_DATE       datetime comment '竣工日期',
   STATE                varchar(3) not null comment '主产品实例/用户的状态。',
   STATE_DATE           datetime not null comment '主产品实例/用户状态变更的时间。',
   primary key (SERV_ID));

alter table USER_PRODUCT.SERV comment '销售品实例在描述业务时都至少存在一个唯一的产品实例，可以用于识别该业务，具体表现为计费的唯一标识，产品实例拥有唯一的接入';

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_TYPE_249                          */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_TYPE_249 on USER_PRODUCT.SERV
(
   BILLING_CYCLE_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_FAMILY_261                              */
/*==============================================================*/
create index I_FKK_PRODUCT_FAMILY_261 on USER_PRODUCT.SERV
(
   PRODUCT_FAMILY_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_153                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_153 on USER_PRODUCT.SERV
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_156                                     */
/*==============================================================*/
create index I_FKK_PRODUCT_156 on USER_PRODUCT.SERV
(
   PRODUCT_ID
);

/*==============================================================*/
/* Index: I_FKK_CUST_157                                        */
/*==============================================================*/
create index I_FKK_CUST_157 on USER_PRODUCT.SERV
(
   CUST_ID
);

/*==============================================================*/
/* Table: SERVICE_OFFER                                         */
/*==============================================================*/
create table USER_PRODUCT.SERVICE_OFFER
(
   SERVICE_OFFER_ID     numeric(9,0) not null comment '用于唯一标识服务提供的内部编号',
   PRODUCT_ID           numeric(9,0) not null comment '用于唯一标识产品的内部编号',
   ACTION_ID            numeric(9,0) not null comment '用于服务提供的动作',
   SERVICE_OFFER_NAME   varchar(50) not null comment '用于命名服务提供',
   SERVICE_OFFER_DESC   varchar(250) not null comment '用于说明注释服务提供',
   SERVICE_OFFER_TYPE   varchar(3) comment '用于标识服务提供类型标识',
   STATE                varchar(3) not null comment '服务提供的状态。 用于标识服务提供状态',
   STATE_DATE           datetime not null comment '服务提供状态变更的时间。',
   EFF_DATE             datetime not null comment '用于记录服务提供生效时间',
   EXP_DATE             datetime comment '用于记录服务提供失效时间',
   primary key (SERVICE_OFFER_ID)
);

alter table USER_PRODUCT.SERVICE_OFFER comment '描述通过向客户提供一些手续和体力工作，完成电信产品实例化的手段。比如提供给客户的一些手续和体力工作，服务提供分为两类：其';

/*==============================================================*/
/* Index: I_FKK_PRODUCT_7                                       */
/*==============================================================*/
create index I_FKK_PRODUCT_7 on USER_PRODUCT.SERVICE_OFFER
(
   PRODUCT_ID
);

/*==============================================================*/
/* Index: I_FKK_ACTION_11                                       */
/*==============================================================*/
create index I_FKK_ACTION_11 on USER_PRODUCT.SERVICE_OFFER
(
   ACTION_ID
);

/*==============================================================*/
/* Table: SERV_ACCT                                             */
/*==============================================================*/
create table USER_ACCT.SERV_ACCT
(
   ACCT_ID              numeric(12,0) not null comment '为每个帐户生成的唯一编号。',
   SERV_ID              numeric(12,0) not null comment '为每个产品实例生成的唯一编号。',
   CUST_ID              numeric(12,0) comment '为了支持为帐户为客户支付增加该字段，可空，如果记录中cust_id字段不为空，优先使用该客户标识
            引入帐户给客户支付概念后，一个帐户为一个客户的多个设备支付就不需要为每个用户建用户和帐户的付费关系了，过户时也不需要涉及到帐务关系的变迁',
   BILLING_CYCLE_TYPE_ID numeric(9,0) not null comment '帐务周期类型',
   ACCT_ITEM_GROUP_ID   numeric(9,0) not null comment '为每个帐目分类方法形成的帐目组生成的唯一编号。',
   PRIORITY             numeric(3,0) not null comment '当前帐户所定制的各付款方式的优先级',
   PAYMENT_RULE_ID      numeric(9,0) not null comment '为每种帐单要求生成的唯一编号。',
   PAYMENT_LIMIT_TYPE   varchar(3) not null comment '表达此条定制关系的支付额度类型。如全额支付，按绝对额度支付，按相对额度支付等。',
   PAYMENT_LIMIT        numeric(12,0) comment '指出本条定制关系的具体额度。其中作为绝对值时，以分为单位。作为百分比时，以万分之一为单位（即表示到小数点后两位）。',
   STATE                varchar(3) not null comment '帐务定制关系的状态。',
   STATE_DATE           datetime not null comment '帐务定制关系状态变更的时间。',
   ID_DEFAULT_ACCT_ID   varchar(1) not null comment '是否默认帐户,体现该记录里的acct_id是否是用户对应的默认帐户',
   primary key (ACCT_ID, SERV_ID, BILLING_CYCLE_TYPE_ID, ACCT_ITEM_GROUP_ID, PRIORITY)
);

alter table USER_ACCT.SERV_ACCT comment '定义每个产品实例的每类帐目由哪个帐户支付、对帐单的要求以及所属的支付规则的关系。';

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_GROUP_56                              */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_GROUP_56 on USER_ACCT.SERV_ACCT
(
   ACCT_ITEM_GROUP_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_77                                         */
/*==============================================================*/
create index I_FKK_ACCT_77 on USER_ACCT.SERV_ACCT
(
   ACCT_ID
);

/*==============================================================*/
/* Index: I_FKK_PAYMENT_RULE_78                                 */
/*==============================================================*/
create index I_FKK_PAYMENT_RULE_78 on USER_ACCT.SERV_ACCT
(
   PAYMENT_RULE_ID
);

/*==============================================================*/
/* Index: I_FKK_SERV_118                                        */
/*==============================================================*/
create index I_FKK_SERV_118 on USER_ACCT.SERV_ACCT
(
   SERV_ID
);

/*==============================================================*/
/* Table: SERV_ADD_ACC_NBR                                      */
/*==============================================================*/
create table USER_PRODUCT.SERV_ADD_ACC_NBR
(
   SERV_ADD_ACC_NBR_ID  numeric(12,0) not null comment '主产品附加号码信息的唯一标识。',
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   AGREEMENT_ID         numeric(9,0) not null comment '识别客户协议的唯一标识号。',
   ACC_ACC_NBR_TYPE     varchar(3) comment '号码类型，包括物理号码、IMSI等',
   ADD_ACC_NBR          varchar(50) not null comment '主产品所附加的外部号码。',
   EFF_DATE             datetime comment '生效时间',
   EXP_DATE             datetime not null comment '失效时间',
   primary key (SERV_ADD_ACC_NBR_ID)
);

alter table USER_PRODUCT.SERV_ADD_ACC_NBR comment '用于支持一机多号';

/*==============================================================*/
/* Index: I_FKK_SERV_IDENTIFICATION_174                         */
/*==============================================================*/
create index I_FKK_SERV_IDENTIFICATION_174 on USER_PRODUCT.SERV_ADD_ACC_NBR
(
   SERV_ID
);

/*==============================================================*/
/* Table: SERV_ATTR                                             */
/*==============================================================*/
create table USER_PRODUCT.SERV_ATTR
(
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   ATTR_ID              numeric(9,0) not null comment '产品属性的唯一标识。',
   ATTR_VAL             varchar(30) not null comment '产品实例附加属性的内容',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SERV_ID, AGREEMENT_ID, ATTR_ID)
);

alter table USER_PRODUCT.SERV_ATTR comment '描述了产品实例的一些附加信息，如adsl速率。产品的动态属性通过名/值对应方式在产品属性表描述，对应着产品实例后，都要记';

/*==============================================================*/
/* Index: I_FKK_SERV_94                                         */
/*==============================================================*/
create index I_FKK_SERV_94 on USER_PRODUCT.SERV_ATTR
(
   SERV_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_159                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_159 on USER_PRODUCT.SERV_ATTR
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_ATTR_165                                */
/*==============================================================*/
create index I_FKK_PRODUCT_ATTR_165 on USER_PRODUCT.SERV_ATTR
(
   ATTR_ID
);

/*==============================================================*/
/* Table: SERV_AUTH                                             */
/*==============================================================*/
create table SERV_AUTH
(
   EVENT_TYPE_ID        numeric(9,0) not null,
   PRODUCT_ID           numeric(9,0) not null,
   SERV_AUTH_TYPE       varchar(3) not null,
   RETURN_CODE          varchar(30) not null,
   primary key (EVENT_TYPE_ID)
);

/*==============================================================*/
/* Table: SERV_BILLING_MODE                                     */
/*==============================================================*/
create table USER_PRODUCT.SERV_BILLING_MODE
(
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   BILLING_MODE         varchar(3) not null comment '付费模式',
   primary key (SERV_ID, AGREEMENT_ID)
);

alter table USER_PRODUCT.SERV_BILLING_MODE comment '用于区分主产品实例的付费模式，主要是后付费方式、预付费方式等，以便于实现预付费、后付费融合和灵活切换。';

/*==============================================================*/
/* Index: I_FKK_SERV_251                                        */
/*==============================================================*/
create index I_FKK_SERV_251 on USER_PRODUCT.SERV_BILLING_MODE
(
   SERV_ID
);

/*==============================================================*/
/* Table: SERV_IDENTIFICATION                                   */
/*==============================================================*/
create table USER_PRODUCT.SERV_IDENTIFICATION
(
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   AGREEMENT_ID         numeric(9,0) not null comment '识别客户协议的唯一标识号。',
   ACC_NBR              varchar(20) not null comment '主产品实例对应的主业务号码，即主要的外部业务号码。在没有一机多号的情况下，就是该主产品实例的业务号码。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SERV_ID, AGREEMENT_ID)
);

alter table USER_PRODUCT.SERV_IDENTIFICATION comment '描述了产品实例所对应的产品的业务号码。';

/*==============================================================*/
/* Index: I_FKK_SERV_92                                         */
/*==============================================================*/
create index I_FKK_SERV_92 on USER_PRODUCT.SERV_IDENTIFICATION
(
   SERV_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_160                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_160 on USER_PRODUCT.SERV_IDENTIFICATION
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Table: SERV_LOCATION                                         */
/*==============================================================*/
create table USER_PRODUCT.SERV_LOCATION
(
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   ADDRESS_ID           numeric(12,0) not null comment '发票上打印的投递地址信息。',
   BUREAU_ID            numeric(9,0) not null comment '表明本实体所对应的产品实例所属的分局。',
   EXCHANGE_ID          numeric(9,0) not null comment '表明本实体所对应的产品实例所属的局向。',
   STAT_REGION_ID       numeric(9,0) not null comment '统计区域标识',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SERV_ID, AGREEMENT_ID)
);

alter table USER_PRODUCT.SERV_LOCATION comment '本实体描述了产品实例所对应产品的安装地址信息。';

/*==============================================================*/
/* Index: I_FKK_STAT_REGION_340                                 */
/*==============================================================*/
create index I_FKK_STAT_REGION_340 on USER_PRODUCT.SERV_LOCATION
(
   STAT_REGION_ID
);

/*==============================================================*/
/* Index: I_FKK_ORGANIZATION_341                                */
/*==============================================================*/
create index I_FKK_ORGANIZATION_341 on USER_PRODUCT.SERV_LOCATION
(
   BUREAU_ID
);

/*==============================================================*/
/* Index: I_FKK_SERV_91                                         */
/*==============================================================*/
create index I_FKK_SERV_91 on USER_PRODUCT.SERV_LOCATION
(
   SERV_ID
);

/*==============================================================*/
/* Index: I_FKK_ADDRESS_112                                     */
/*==============================================================*/
create index I_FKK_ADDRESS_112 on USER_PRODUCT.SERV_LOCATION
(
   ADDRESS_ID
);

/*==============================================================*/
/* Index: I_FKK_BILLING_REGION_113                              */
/*==============================================================*/
create index I_FKK_BILLING_REGION_113 on USER_PRODUCT.SERV_LOCATION
(
   EXCHANGE_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_162                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_162 on USER_PRODUCT.SERV_LOCATION
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Table: SERV_POINTS_REWARD_RECORD                             */
/*==============================================================*/
create table PARTY_USER.SERV_POINTS_REWARD_RECORD
(
   PRESENT_ITEM_ID      numeric(12,0) not null comment '用户积分兑换情况的唯一标识。',
   REGION_ID            numeric(9,0) not null comment '区域标识',
   SERV_ID              numeric(12,0) not null comment '表明本优惠套餐是属于本客户下的具体某个实体的编号。',
   INTEGRAL_VALUE       numeric(8,0) not null comment '兑换的积分。',
   ACCT_ITEM_ID         numeric(9,0) not null comment '赠送帐目标识',
   PRESENT_ID           numeric(12,0) not null comment '赠品定义的唯一标识。',
   INTEGRAL_REAULT_ID   numeric(12,0) comment '积分评估结果标识',
   PRESENT_VALUE        numeric(8,0) not null comment '积分上限',
   EFF_DATE             datetime comment '本记录的生效时间。',
   EXP_DATE             datetime not null comment '本记录的失效时间。',
   OPER_DATE            datetime not null comment '操作日期',
   OPER_STAFF_ID        numeric(9,0) not null comment '接受付款操作的营业员。',
   OPER_SITE_ID         numeric(9,0) not null comment '操作地点',
   STATE                varchar(3) comment '用户积分兑换情况的状态。',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '表明余额对象性质，可选客户/帐户/用户',
   ACCT_MONTH           varchar(6) not null comment '帐务月份',
   primary key (PRESENT_ITEM_ID)
);

alter table PARTY_USER.SERV_POINTS_REWARD_RECORD comment '记录每次积分兑换信息。';

/*==============================================================*/
/* Index: I_FKK_INTEGRAL_RESULT_279                             */
/*==============================================================*/
create index I_FKK_INTEGRAL_RESULT_279 on PARTY_USER.SERV_POINTS_REWARD_RECORD
(
   INTEGRAL_REAULT_ID
);

/*==============================================================*/
/* Index: I_FKK_PRESENT_281                                     */
/*==============================================================*/
create index I_FKK_PRESENT_281 on PARTY_USER.SERV_POINTS_REWARD_RECORD
(
   PRESENT_ID
);

/*==============================================================*/
/* Table: SERV_POINTS_REWARD_RULE                               */
/*==============================================================*/
create table PARTY_USER.SERV_POINTS_REWARD_RULE
(
   PRESENT_RULE_ID      numeric(9,0) not null comment '用户积分兑换规则的唯一标识。',
   REGION_ID            numeric(9,0) not null comment '区域标识',
   INTEGRAL_FLOOR       numeric(8,0) not null comment '积分下限',
   INTEGRAL_CEIL        numeric(8,0) not null comment '积分上限',
   PRESENT_ID           numeric(9,0) not null comment '赠品定义的唯一标识。',
   PRESENT_VALUE        numeric(8,0) not null comment '积分上限',
   STATE                varchar(3) comment '用户积分兑换规则的状态。',
   EFF_DATE             datetime not null comment '本记录的生效时间。',
   EXP_DATE             datetime comment '本记录的失效时间。',
   primary key (PRESENT_RULE_ID)
);

alter table PARTY_USER.SERV_POINTS_REWARD_RULE comment '描述积分的回报规则';

/*==============================================================*/
/* Index: I_FKK_PRESENT_282                                     */
/*==============================================================*/
create index I_FKK_PRESENT_282 on PARTY_USER.SERV_POINTS_REWARD_RULE
(
   PRESENT_ID
);

/*==============================================================*/
/* Table: SERV_PRODUCT                                          */
/*==============================================================*/
create table USER_PRODUCT.SERV_PRODUCT
(
   SERV_PRODUCT_ID      numeric(12,0) not null comment '附属产品实例的唯一标识。',
   SERV_ID              numeric(9,0) not null comment '主产品实例的唯一标识。',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   PRODUCT_ID           numeric(9,0) not null comment '唯一标识一个产品',
   CREATED_DATE         datetime not null comment '建立时间',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SERV_PRODUCT_ID)
);

alter table USER_PRODUCT.SERV_PRODUCT comment '描述了主产品实例具有的附加的产品实例。';

/*==============================================================*/
/* Index: I_FKK_SERV_90                                         */
/*==============================================================*/
create index I_FKK_SERV_90 on USER_PRODUCT.SERV_PRODUCT
(
   SERV_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_158                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_158 on USER_PRODUCT.SERV_PRODUCT
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_163                                     */
/*==============================================================*/
create index I_FKK_PRODUCT_163 on USER_PRODUCT.SERV_PRODUCT
(
   PRODUCT_ID
);

/*==============================================================*/
/* Table: SERV_PRODUCT_ATTR                                     */
/*==============================================================*/
create table USER_PRODUCT.SERV_PRODUCT_ATTR
(
   SERV_PRODUCT_ID      numeric(12,0) not null comment '附属产品实例的唯一标识。',
   ATTR_ID              numeric(9,0) not null comment '产品属性的唯一标识。',
   ATTR_VAL             varchar(30) not null comment '产品实例附加属性的内容',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SERV_PRODUCT_ID, ATTR_ID)
);

alter table USER_PRODUCT.SERV_PRODUCT_ATTR comment '描述了附加产品实例所附带的属性的信息。
附属产品实例属性中包含了付费模式信息，以指明本附属产品实例约定的付费';

/*==============================================================*/
/* Index: I_FKK_SERV_PRODUCT_89                                 */
/*==============================================================*/
create index I_FKK_SERV_PRODUCT_89 on USER_PRODUCT.SERV_PRODUCT_ATTR
(
   SERV_PRODUCT_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_ATTR_164                                */
/*==============================================================*/
create index I_FKK_PRODUCT_ATTR_164 on USER_PRODUCT.SERV_PRODUCT_ATTR
(
   ATTR_ID
);

/*==============================================================*/
/* Table: SERV_RELATION                                         */
/*==============================================================*/
create table USER_PRODUCT.SERV_RELATION
(
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   AGREEMENT_ID         numeric(9,0) not null comment '识别客户协议的唯一标识号。',
   Z_SERV_ID            varchar(20) not null comment '描述主产品实例关系时的Z端主产品实例。',
   RELATION_TYPE        varchar(3) not null comment '描述本主产品实例与Z端主产品实例存在那种关系。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SERV_ID, AGREEMENT_ID)
);

alter table USER_PRODUCT.SERV_RELATION comment '描述由客户定制的主产品实例之间的关系，如为另外一个主产品实例提供停机担保的关系。';

/*==============================================================*/
/* Index: I_FKK_SERV_95                                         */
/*==============================================================*/
create index I_FKK_SERV_95 on USER_PRODUCT.SERV_RELATION
(
   SERV_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_163                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_163 on USER_PRODUCT.SERV_RELATION
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Table: SERV_STATE_ATTR                                       */
/*==============================================================*/
create table USER_PRODUCT.SERV_STATE_ATTR
(
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   BILLING_CYCLE_TYPE_ID numeric(9,0) not null comment '帐务周期类型',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   OWE_BUSINESS_TYPE_ID numeric(9,0) comment '欠费业务类型的唯一标识。',
   STATE                varchar(3) not null comment '主产品实例/用户的状态。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SERV_ID, BILLING_CYCLE_TYPE_ID, AGREEMENT_ID)
);

alter table USER_PRODUCT.SERV_STATE_ATTR comment '表达主产品实例状态及其历史变化情况的辅助表。
';

/*==============================================================*/
/* Index: I_FKK_OWE_BUSINESS_TYPE_238                           */
/*==============================================================*/
create index I_FKK_OWE_BUSINESS_TYPE_238 on USER_PRODUCT.SERV_STATE_ATTR
(
   OWE_BUSINESS_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_SERV_225                                        */
/*==============================================================*/
create index I_FKK_SERV_225 on USER_PRODUCT.SERV_STATE_ATTR
(
   SERV_ID
);

/*==============================================================*/
/* Table: SERV_SUBSRIBER                                        */
/*==============================================================*/
create table USER_PRODUCT.SERV_SUBSRIBER
(
   SERV_ID              numeric(12,0) not null comment '主产品实例的唯一标识。',
   AGREEMENT_ID         numeric(12,0) not null comment '识别客户协议的唯一标识号。',
   USER_NAME            varchar(250) not null comment '表明本实体所对应的产品实例所对应的产品的使用者名称。',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (SERV_ID, AGREEMENT_ID)
);

alter table USER_PRODUCT.SERV_SUBSRIBER comment '描述了产品实例所对应的具体的产品使用者的属性。
';

/*==============================================================*/
/* Index: I_FKK_SERV_93                                         */
/*==============================================================*/
create index I_FKK_SERV_93 on USER_PRODUCT.SERV_SUBSRIBER
(
   SERV_ID
);

/*==============================================================*/
/* Index: I_FKK_AGREEMENT_161                                   */
/*==============================================================*/
create index I_FKK_AGREEMENT_161 on USER_PRODUCT.SERV_SUBSRIBER
(
   AGREEMENT_ID
);

/*==============================================================*/
/* Table: SETTLE_CATALOG                                        */
/*==============================================================*/
create table USER_ACCT.SETTLE_CATALOG
(
   CATALOG_ID           numeric(9,0) not null comment '用于唯一标识结算目录的内部编号',
   CATALOG_TYPE         varchar(3) comment '用于标识结算目录的类型,主要是包括了合作伙伴、内部实体、对等运营商等实体。',
   CATALOG_NAME         varchar(50) not null comment '用于命名结算目录',
   CATALOG_DESC         varchar(250) not null comment '用于说明注释结算目录',
   primary key (CATALOG_ID)
);

alter table USER_ACCT.SETTLE_CATALOG comment '结算目录';

/*==============================================================*/
/* Index: I_FKK_PARTNER_342                                     */
/*==============================================================*/
create index I_FKK_PARTNER_342 on USER_ACCT.SETTLE_CATALOG
(
   CATALOG_ID
);

/*==============================================================*/
/* Table: SETTLE_CATALOG_ITEM                                   */
/*==============================================================*/
create table USER_ACCT.SETTLE_CATALOG_ITEM
(
   CATALOG_ITEM_ID      numeric(9,0) not null comment '结算目录节点的唯一标识。',
   PARENT_CATALOG_ITEM_ID numeric(9,0) not null comment '上层节点的标识，用于表达目录的层次关系。',
   CATALOG_ID           numeric(9,0) not null comment '用于唯一标识结算目录的内部编号',
   CATALOG_ITEM_TYPE    varchar(3) not null comment '目录节点的类型。',
   CATALOG_ITEM_NAME    varchar(50) not null comment '目录节点的名称。',
   CATALOG_ITEM_DESC    varchar(250) not null comment '用于说明注释元素',
   primary key (CATALOG_ITEM_ID)
);

alter table USER_ACCT.SETTLE_CATALOG_ITEM comment '结算目录节点';

/*==============================================================*/
/* Index: I_FKK_SETTLE_CATALOG_343                              */
/*==============================================================*/
create index I_FKK_SETTLE_CATALOG_343 on USER_ACCT.SETTLE_CATALOG_ITEM
(
   CATALOG_ID
);

/*==============================================================*/
/* Table: SETTLE_CATALOG_ITEM_ELEMENT                           */
/*==============================================================*/
create table USER_ACCT.SETTLE_CATALOG_ITEM_ELEMENT
(
   CATALOG_ITEM_ID      numeric(9,0) not null comment '所属产品目录节点的唯一标识。',
   ELEMENT_TYPE         varchar(3) not null comment '目录中具体元素的ID',
   ELEMENT_ID           numeric(9,0) not null comment '元素标识',
   primary key (CATALOG_ITEM_ID)
);

alter table USER_ACCT.SETTLE_CATALOG_ITEM_ELEMENT comment '目录节点所包含的元素。 ';

/*==============================================================*/
/* Index: I_FKK_SETTLE_CATALOG_ITEM_344                         */
/*==============================================================*/
create index I_FKK_SETTLE_CATALOG_ITEM_344 on USER_ACCT.SETTLE_CATALOG_ITEM_ELEMENT
(
   CATALOG_ITEM_ID
);

/*==============================================================*/
/* Index: I_FKK_SETTLE_RULE_345                                 */
/*==============================================================*/
create index I_FKK_SETTLE_RULE_345 on USER_ACCT.SETTLE_CATALOG_ITEM_ELEMENT
(
   ELEMENT_ID
);

/*==============================================================*/
/* Table: SETTLE_RULE                                           */
/*==============================================================*/
create table USER_ACCT.SETTLE_RULE
(
   SETTLE_RULE_ID       numeric(9,0) not null comment '定价计划的标识',
   EVENT_PRICING_STRATEGY_ID numeric(9,0) comment '事件定价策略的标识',
   SETTLE_RULE_NAME     varchar(50) not null comment '该定价计划的名称',
   SETTLE_RULE_DESC     varchar(4000) not null comment '定价计划的资费说明。',
   PARAM_DESC           varchar(4000) not null comment '定价计划参数的说明。',
   primary key (SETTLE_RULE_ID));

alter table USER_ACCT.SETTLE_RULE comment '结算规则';

/*==============================================================*/
/* Index: I_FKK_EVENT_PRICING_STRAT_346                         */
/*==============================================================*/
create index I_FKK_EVENT_PRICING_STRAT_346 on USER_ACCT.SETTLE_RULE
(
   EVENT_PRICING_STRATEGY_ID
);

/*==============================================================*/
/* Table: SHARE_RULE_TYPE                                       */
/*==============================================================*/
create table USER_ACCT.SHARE_RULE_TYPE
(
   SHARE_RULE_TYPE_ID   numeric(5,0) not null comment '共享规则类型标识',
   SHARE_RULE_TYPE_NAME varchar(50) not null comment '共享规则类型名称',
   primary key (SHARE_RULE_TYPE_ID)
);

alter table USER_ACCT.SHARE_RULE_TYPE comment '共享规则类型';

/*==============================================================*/
/* Table: SOURCE_EVENT                                          */
/*==============================================================*/
create table USER_EVENT.SOURCE_EVENT
(
   EVENT_ID             numeric(12,0) not null comment '唯一标识一个计费系统计费处理的源数据信息',
   EVENT_CONTENT_ID     numeric(12,0) not null comment '由该位置标识找出事件内容具体位置',
   SOURCE_EVENT_TYPE    numeric(9,0) comment '唯一标识一种源事件类型，如语音市话跳表事件、语音计时事件、互联网使用事件、互联星空使用事件等。',
   primary key (EVENT_ID)
);

alter table USER_EVENT.SOURCE_EVENT comment '源事件（source_event）是计费系统计费处理的源数据信息，主要包含三个大类内容：1）客户交互事件；2）使用记录；';

/*==============================================================*/
/* Index: I_FKK_EVENT_CONTENT_INDEX_306                         */
/*==============================================================*/
create index I_FKK_EVENT_CONTENT_INDEX_306 on USER_EVENT.SOURCE_EVENT
(
   EVENT_CONTENT_ID
);

/*==============================================================*/
/* Index: I_FKK_SOURCE_EVENT_TYPE_316                           */
/*==============================================================*/


/*==============================================================*/
/* Table: SOURCE_EVENT_FORMAT                                   */
/*==============================================================*/
create table USER_EVENT.SOURCE_EVENT_FORMAT
(
   EVENT_FORMAT_ID      numeric(9,0) not null comment '唯一标识一个源事件格式',
   SOURCE_EVENT_TYPE    numeric(9,0) comment '唯一标识一种源事件类型，如语音市话跳表事件、语音计时事件、互联网使用事件、互联星空使用事件等。',
   EVFORMAT_CLASS       varchar(3) not null comment '源事件格式类型：普通格式类型、其它格式类型',
   STATE                varchar(3) comment '源事件格式的状态。',
   EFF_DATE             datetime not null comment '源事件格式的生效时间',
   EXP_DATE             datetime comment '源事件格式的失效时间',
   NAME                 varchar(50) not null comment '名称',
   primary key (EVENT_FORMAT_ID)
);

alter table USER_EVENT.SOURCE_EVENT_FORMAT comment '可预定义和扩展的源事件的格式信息。源事件格式包含数据包格式、记录格式等，同时定义了源事件的存储方式，如：数据流、文件、库';

/*==============================================================*/
/* Index: I_FKK_SOURCE_EVENT_TYPE_320                           */
/*==============================================================*/
create index I_FKK_SOURCE_EVENT_TYPE_320 on USER_EVENT.SOURCE_EVENT_FORMAT
(
   SOURCE_EVENT_TYPE
);

/*==============================================================*/
/* Table: SOURCE_EVENT_FORMAT_ITEM                              */
/*==============================================================*/
create table USER_EVENT.SOURCE_EVENT_FORMAT_ITEM
(
   EVENT_FORMAT_ITEM_ID numeric(9,0) not null comment '唯一标识一个源事件格式项',
   EVENT_FORMAT_SEGMENT_ID numeric(9,0) not null comment '标识源事件格式项所属的源事件格式段',
   EVENT_ATTR_ID        numeric(9,0) not null comment '标识源事件格式项包含的源事件属性',
   DATA_FORMAT_ID       numeric(9,0) comment '源事件格式项的数据格式',
   LOCATION             numeric(8,0) not null comment '源事件属性在源事件格式段中的位置',
   LENGTH               numeric(8,0) not null comment '源事件属性在源事件格式段中的所占的长度',
   CODE                 varchar(3) not null comment '源事件属性在源事件格式段中的编码，如：ASCII、BCD、二进制、NUMBER等',
   PREFIX               varchar(30) not null comment '源事件属性在源事件格式段中的前缀信息',
   SUFFIX               varchar(30) not null comment '源事件属性在源事件格式段中的后缀信息',
   ALIGNMENT            varchar(3) not null comment '源事件格式项的对齐方式。',
   NAME                 varchar(50) not null comment '源事件格式项名称',
   primary key (EVENT_FORMAT_ITEM_ID)
);

alter table USER_EVENT.SOURCE_EVENT_FORMAT_ITEM comment '定义了构成源事件格式项的源事件属性在源事件格式段中的位置、长度、编码方式（ASCII、BCD、二进制等）等相关信息。
                                                        ';

/*==============================================================*/
/* Index: I_FKK_DATA_FORMAT_301                                 */
/*==============================================================*/
create index I_FKK_DATA_FORMAT_301 on USER_EVENT.SOURCE_EVENT_FORMAT_ITEM
(
   DATA_FORMAT_ID
);

/*==============================================================*/
/* Index: I_FKK_SOURCE_EVENT_FORMAT_314                         */
/*==============================================================*/
create index I_FKK_SOURCE_EVENT_FORMAT_314 on USER_EVENT.SOURCE_EVENT_FORMAT_ITEM
(
   EVENT_FORMAT_SEGMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_EVENT_ATTR_315                                  */
/*==============================================================*/
create index I_FKK_EVENT_ATTR_315 on USER_EVENT.SOURCE_EVENT_FORMAT_ITEM
(
   EVENT_ATTR_ID
);

/*==============================================================*/
/* Table: SOURCE_EVENT_FORMAT_NORMAL                            */
/*==============================================================*/
create table USER_EVENT.SOURCE_EVENT_FORMAT_NORMAL
(
   EVENT_FORMAT_ID      numeric(9,0) not null comment '唯一标识一个源事件格式',
   EVENT_FORMAT_TYPE    varchar(3) comment '事件格式的格式类型。',
   IS_HEAD_INCLUDED     varchar(1) not null comment '对格式类型为数据包类型的源事件，是否包含包头信息',
   IS_TAIL_INCLUDED     varchar(1) not null comment '对格式类型为数据包类型的源事件，是否包含包尾信息',
   NAME                 varchar(50) not null comment '名称',
   primary key (EVENT_FORMAT_ID)
);

alter table USER_EVENT.SOURCE_EVENT_FORMAT_NORMAL comment '可预定义和扩展的普通源事件的格式信息。源事件格式包含数据包格式、记录格式等，源事件格式由源事件格式段（event for';

/*==============================================================*/
/* Index: I_FKK_SOURCE_EVENT_FORMAT_317                         */
/*==============================================================*/
create index I_FKK_SOURCE_EVENT_FORMAT_317 on USER_EVENT.SOURCE_EVENT_FORMAT_NORMAL
(
   EVENT_FORMAT_ID
);

/*==============================================================*/
/* Table: SOURCE_EVENT_FORMAT_OTHER                             */
/*==============================================================*/
create table USER_EVENT.SOURCE_EVENT_FORMAT_OTHER
(
   EVENT_FORMAT_ID      numeric(9,0) not null comment '唯一标识一个源事件格式',
   NAME                 varchar(50) not null comment '名称',
   primary key (EVENT_FORMAT_ID)
);

alter table USER_EVENT.SOURCE_EVENT_FORMAT_OTHER comment '定义其它无法在普通源事件格式中表示的格式，为源事件格式的扩展留下空间。';

/*==============================================================*/
/* Index: I_FKK_SOURCE_EVENT_FORMAT_318                         */
/*==============================================================*/
create index I_FKK_SOURCE_EVENT_FORMAT_318 on USER_EVENT.SOURCE_EVENT_FORMAT_OTHER
(
   EVENT_FORMAT_ID
);

/*==============================================================*/
/* Table: SOURCE_EVENT_FORMAT_SEGMENT                           */
/*==============================================================*/
create table USER_EVENT.SOURCE_EVENT_FORMAT_SEGMENT
(
   EVENT_FORMAT_SEGMENT_ID numeric(9,0) not null comment '唯一标识一个格式段',
   EVENT_FORMAT_ID      numeric(9,0) comment '唯一标识一个源事件格式',
   SEGMENT_TYPE         varchar(3) not null comment '标识源事件格式段的类型：包头、包尾、内容，对数据包类型的源事件，可包含上述三个部分的内容，对记录类型的源事件，格式段类型可只为"内容"。',
   LENGTH               numeric(8,0) not null comment '格式段的长度',
   COLUMN_NUM           numeric(8,0) not null comment '格式段包含的列数',
   `SEPARATOR`          varchar(30) not null comment '分隔符',
   TERMINATOR           varchar(30) not null comment '结束符',
   NAME                 varchar(50) not null comment '名称',
   primary key (EVENT_FORMAT_SEGMENT_ID)
);

alter table USER_EVENT.SOURCE_EVENT_FORMAT_SEGMENT comment '定义了针对不同源事件格式类型（如：数据包、记录类型）可能拥有的包头、包尾、内容等格式段信息，包括长度、列数、分隔符、结束';

/*==============================================================*/
/* Index: I_FKK_SOURCE_EVENT_FORMAT_319                         */
/*==============================================================*/
create index I_FKK_SOURCE_EVENT_FORMAT_319 on USER_EVENT.SOURCE_EVENT_FORMAT_SEGMENT
(
   EVENT_FORMAT_ID
);

/*==============================================================*/
/* Table: SOURCE_EVENT_TYPE                                     */
/*==============================================================*/
create table USER_EVENT.SOURCE_EVENT_TYPE
(
   SOURCE_EVENT_TYPE    numeric(9,0) not null comment '唯一标识一种源事件类型，如语音市话跳表事件、语音计时事件、互联网使用事件、互联星空使用事件等。',
   SOURCE_EVENT_TYPE_SUM varchar(3) not null comment '标识源事件类型的归类信息，分为客户交互事件、使用事件、内部业务事件三个大类。',
   NAME                 varchar(50) not null comment '源事件类型的名称',
   STATE                varchar(3) comment '源事件类型的状态。',
   EFF_DATE             datetime not null comment '源事件类型的生效时间',
   EXP_DATE             datetime comment '源事件类型的失效时间',
   primary key (SOURCE_EVENT_TYPE)
);

alter table USER_EVENT.SOURCE_EVENT_TYPE comment '描述了源事件的分类信息。源事件从总体上划分为客户交互事件、使用事件、内部业务事件三个大类。对使用事件，按照产生事件的设备';

/*==============================================================*/
/* Table: SPECIAL_HEAD                                          */
/*==============================================================*/
create table USER_LOCATION.SPECIAL_HEAD
(
   HEAD_ID              numeric(9,0) not null comment '号头标识',
   HEAD                 varchar(50) not null comment '号头',
   EMULATORY_PARTNER_ID numeric(9,0) not null default 0 comment '运营商的唯一标识。',
   LATN_ID              numeric(9,0) not null comment '本地网标识',
   HEAD_TYPE            varchar(3) not null comment '表达不同的号头类型，如特服号码、智能网接入、IP接入、数据接入等',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (HEAD_ID)
);

alter table USER_LOCATION.SPECIAL_HEAD comment '特殊号头信息';

/*==============================================================*/
/* Index: I_FKK_BILLING_REGION_324                              */
/*==============================================================*/
create index I_FKK_BILLING_REGION_324 on USER_LOCATION.SPECIAL_HEAD
(
   LATN_ID
);

/*==============================================================*/
/* Index: I_FKK_EMULATORY_PARTNER_331                           */
/*==============================================================*/
create index I_FKK_EMULATORY_PARTNER_331 on USER_LOCATION.SPECIAL_HEAD
(
   EMULATORY_PARTNER_ID
);

/*==============================================================*/
/* Table: SPECIAL_PAYMENT                                       */
/*==============================================================*/
create table USER_ACCT.SPECIAL_PAYMENT
(
   SPE_PAYMENT_ID       numeric(9,0) not null comment '为每种专款专用生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   PARTNER_ID           numeric(9,0) not null comment '专款专用的运营商范围，0表示不限定运营商',
   PRODUCT_ID           numeric(9,0) not null comment '用于唯一标识产品/服务的内部编号',
   ACCT_ITEM_GROUP_ID   numeric(9,0) not null comment '为每个帐目组生成的唯一编号。',
   primary key (SPE_PAYMENT_ID, PARTNER_ID, PRODUCT_ID, ACCT_ITEM_GROUP_ID));

alter table USER_ACCT.SPECIAL_PAYMENT comment '记录专款专用的具体详细定义。';

/*==============================================================*/
/* Index: I_FKK_SPECIAL_PAYMENT_DESC_80                         */
/*==============================================================*/
create index I_FKK_SPECIAL_PAYMENT_DESC_80 on USER_ACCT.SPECIAL_PAYMENT
(
   SPE_PAYMENT_ID
);

/*==============================================================*/
/* Index: I_FKK_PARTNER_138                                     */
/*==============================================================*/
create index I_FKK_PARTNER_138 on USER_ACCT.SPECIAL_PAYMENT
(
   PARTNER_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_139                                     */
/*==============================================================*/
create index I_FKK_PRODUCT_139 on USER_ACCT.SPECIAL_PAYMENT
(
   PRODUCT_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_GROUP_297                             */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_GROUP_297 on USER_ACCT.SPECIAL_PAYMENT
(
   ACCT_ITEM_GROUP_ID
);

/*==============================================================*/
/* Table: SPECIAL_PAYMENT_DESC                                  */
/*==============================================================*/
create table USER_ACCT.SPECIAL_PAYMENT_DESC
(
   SPE_PAYMENT_ID       numeric(9,0) not null comment '为每种专款专用生成的唯一编号，只具有逻辑上的含义，没有物理意义。',
   SPE_PAYMENT_DESC     varchar(250) not null comment '专款专用内容描述',
   primary key (SPE_PAYMENT_ID)
);

alter table USER_ACCT.SPECIAL_PAYMENT_DESC comment '描述一种专款专用的业务类型';

/*==============================================================*/
/* Table: STAFF                                                 */
/*==============================================================*/
create table PARTY_USER.STAFF
(
   STAFF_ID             numeric(9,0) not null comment '员工标识',
   STAFF_CODE           varchar(15) not null comment '员工的外部编号。',
   PASSWD               varchar(30) not null comment '员工的口令，可根据要求存储加密后的密码信息。',
   SCOPE_LEVEL          varchar(3) not null comment '范围级别，次级操作员不能维护同级和上一级的操作员信息和其他相关信息（如授权信息）',
   STAFF_DESC           varchar(250) not null comment '员工的详细说明。',
   OPERATE_ORG_ID       numeric(12,0) comment '组织标识',
   PARENT_PARTYROLEID   numeric(9,0) comment '企业客户的上级主管',
   primary key (STAFF_ID)
);

alter table PARTY_USER.STAFF comment '员工与管理者是中国电信企业内部的参与人在电信业务活动中承担的角色，他们在电信业务活动中具有相关的权限。
员工';

/*==============================================================*/
/* Index: I_FKK_ORGANIZATION_250                                */
/*==============================================================*/
create index I_FKK_ORGANIZATION_250 on PARTY_USER.STAFF
(
   OPERATE_ORG_ID
);

/*==============================================================*/
/* Index: I_FKK_STAFF_103                                       */
/*==============================================================*/
create index I_FKK_STAFF_103 on PARTY_USER.STAFF
(
   PARENT_PARTYROLEID
);

/*==============================================================*/
/* Index: I_FKK_PARTY_ROLE_184                                  */
/*==============================================================*/
create index I_FKK_PARTY_ROLE_184 on PARTY_USER.STAFF
(
   STAFF_ID
);

/*==============================================================*/
/* Table: STAFF_PRIVILEGE                                       */
/*==============================================================*/
create table PARTY_USER.STAFF_PRIVILEGE
(
   PARTY_ROLE_ID        numeric(9,0) not null comment '员工标识',
   PRIVILEGE_ID         numeric(9,0) not null comment '权限的唯一标识。',
   primary key (PARTY_ROLE_ID, PRIVILEGE_ID)
);

alter table PARTY_USER.STAFF_PRIVILEGE comment '定义员工享受的权限';

/*==============================================================*/
/* Index: I_FKK_STAFF_192                                       */
/*==============================================================*/
create index I_FKK_STAFF_192 on PARTY_USER.STAFF_PRIVILEGE
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Index: I_FKK_PRIVILEGE_193                                   */
/*==============================================================*/
create index I_FKK_PRIVILEGE_193 on PARTY_USER.STAFF_PRIVILEGE
(
   PRIVILEGE_ID
);

/*==============================================================*/
/* Table: STAFF_ROLE                                            */
/*==============================================================*/
create table PARTY_USER.STAFF_ROLE
(
   PARTY_ROLE_ID        numeric(9,0) not null comment '员工标识',
   ROLE_ID              numeric(9,0) not null comment '权限组的唯一标识。',
   primary key (PARTY_ROLE_ID, ROLE_ID)
);

alter table PARTY_USER.STAFF_ROLE comment '员工享受的权限组';

/*==============================================================*/
/* Index: I_FKK_STAFF_190                                       */
/*==============================================================*/
create index I_FKK_STAFF_190 on PARTY_USER.STAFF_ROLE
(
   PARTY_ROLE_ID
);

/*==============================================================*/
/* Index: I_FKK_ROLE_191                                        */
/*==============================================================*/
create index I_FKK_ROLE_191 on PARTY_USER.STAFF_ROLE
(
   ROLE_ID
);

/*==============================================================*/
/* Table: STATS_CHECK2                                          */
/*==============================================================*/
create table USER_STAT.STATS_CHECK2
(
   CHECK_ID             numeric(9,0) not null comment '稽核标识',
   TREE_NODE_ID         numeric(9,0) comment '树节点标识，可以是内部树，也可以是外部树',
   CHECK_TYPE           numeric(5,0) not null comment '稽核类别',
   CHECK_NAME           varchar(50) not null comment '稽核名称',
   REF_RELATION_TYPE    numeric(5,0) not null comment '参考关系类别',
   REF_TREE_TYPE_ID     numeric(9,0) not null comment '参考目录编码',
   REF_RELATION         varchar(4000) not null comment '参考关系',
   CHECK_OPER           varchar(15) not null comment '稽核运算符',
   CHECK_RELATION_TYPE  numeric(5,0) not null comment '稽核关系类别',
   CHECK_TREE_TYPE_ID   numeric(9,0) not null comment '稽核目录编码',
   CHECK_RELATION       varchar(4000) not null comment '稽核参考关系',
   DESCRIPTION          varchar(250) not null comment '关系表述',
   primary key (CHECK_ID)
);

alter table USER_STAT.STATS_CHECK2 comment '三棵树稽核关系定义';

/*==============================================================*/
/* Index: I_FKK_INTERNAL_TREE_STRUCT_358                        */
/*==============================================================*/
create index I_FKK_INTERNAL_TREE_STRUCT_358 on USER_STAT.STATS_CHECK2
(
   TREE_NODE_ID
);

/*==============================================================*/
/* Index: I_FKK_EXTERNAL_TREE_STRUCT_358                        */
/*==============================================================*/
create index I_FKK_EXTERNAL_TREE_STRUCT_358 on USER_STAT.STATS_CHECK2
(
   TREE_NODE_ID
);

/*==============================================================*/
/* Table: STAT_REGION                                           */
/*==============================================================*/
create table USER_LOCATION.STAT_REGION
(
   REGION_ID            numeric(9,0) not null comment '区域标识',
   PARENT_REGION_ID     numeric(9,0) comment '上级区域的唯一标识，用于表示层次关系。',
   REGION_LEVEL         varchar(3) not null comment '区域级别，越高级别的表明该区域越大。',
   primary key (REGION_ID)
);

alter table USER_LOCATION.STAT_REGION comment '电信营销区域是中国电信根据电信营销管理需要而进行区域划分各种划分范围，包括地市、片区/社区/服务区等';

/*==============================================================*/
/* Index: I_FKK_STAT_REGION_327                                 */
/*==============================================================*/
create index I_FKK_STAT_REGION_327 on USER_LOCATION.STAT_REGION
(
   PARENT_REGION_ID
);

/*==============================================================*/
/* Index: I_FKK_REGION_336                                      */
/*==============================================================*/
create index I_FKK_REGION_336 on USER_LOCATION.STAT_REGION
(
   REGION_ID
);

/*==============================================================*/
/* Table: STA_TARGET_SYNTAX2                                    */
/*==============================================================*/
create table USER_STAT.STA_TARGET_SYNTAX2
(
   EXTERNAL_TREE_NODE_ID numeric(9,0) comment '外部树节点标识',
   SYNTAX               varchar(4000) not null comment '获取游离指标值的语法'
);

alter table USER_STAT.STA_TARGET_SYNTAX2 comment '定义游离指标及取值语法';

/*==============================================================*/
/* Index: I_FKK_EXTERNAL_TREE_STRUCT_355                        */
/*==============================================================*/
create index I_FKK_EXTERNAL_TREE_STRUCT_355 on USER_STAT.STA_TARGET_SYNTAX2
(
   EXTERNAL_TREE_NODE_ID
);

/*==============================================================*/
/* Table: SUB_BILLING_CYCLE                                     */
/*==============================================================*/
create table USER_ACCT.SUB_BILLING_CYCLE
(
   SUB_BILLING_CYCLE_ID numeric(9,0) not null comment '定义主周期外的各子周期',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '本子周期对应的主帐务周期标识',
   SUB_BILLING_CYCLE_TYPE varchar(3) not null comment '子周期作用的类型。',
   SUB_BILLING_CYCLE_DESC varchar(250) not null comment '子周期的用途说明。',
   EFF_DATE             datetime not null comment '子周期的开始日期',
   EXP_DATE             datetime comment '子周期的截止日期',
   primary key (SUB_BILLING_CYCLE_ID));

alter table USER_ACCT.SUB_BILLING_CYCLE comment '定义当前主周期下存在不同起止时间和用途等的子周期,比如与主周期时间起止不同的当前统计周期';

/*==============================================================*/
/* Index: I_FKK_BILLING_CYCLE_114                               */
/*==============================================================*/
create index I_FKK_BILLING_CYCLE_114 on USER_ACCT.SUB_BILLING_CYCLE
(
   BILLING_CYCLE_ID
);

/*==============================================================*/
/* Table: TARGET_TREE2                                          */
/*==============================================================*/
create table USER_STAT.TARGET_TREE2
(
   TARGET_TREE_ID       numeric(9,0) not null comment '树标识',
   TARGET_TREE_NAME     varchar(50) not null comment '目录名称',
   TARGET_TREE_TYPE     numeric(5,0) not null comment '指标树类别，取值如下：
            10 –内部树
            20 –外部树
            
            ',
   STA_TREE_FLAG        numeric(5,0) not null comment '标识不同部门统计范畴，如针对财务部、市场部、综合统计部门分别设置取值：
            10 –-财务统计
            20 –指标统计
            30 –销售统计
            
            ',
   TREE_LEVEL           varchar(30) not null comment '树干级别长度，记录内容必须填满至20位，如23300000000000000000，数字之和小于等于20。上述表示3级，其中第1级长度2位，第2级长度3位，第3级长度3位。',
   primary key (TARGET_TREE_ID)
);

alter table USER_STAT.TARGET_TREE2 comment '定义内部树、外部树的目录';

/*==============================================================*/
/* Table: TARIFF                                                */
/*==============================================================*/
create table USER_PRICING.TARIFF
(
   TARIFF_ID            numeric(9,0) not null comment '资费标准的标识',
   TARIFF_TYPE          varchar(3) not null comment '用于表达本资费标准为一次性费用、循环费用和使用费中的哪些类型。',
   PRICING_SECTION_ID   numeric(9,0) not null comment '说明该资费标准归属的定价段落',
   RESOURCE_ID          numeric(9,0) not null comment '用于说明该优惠将对哪种积量类型产生影响，主要用于赠送固定值',
   ACTION_ID            numeric(9,0) comment '用于说明一次性费用的动作类型，如装机、拆机、过户、改号等。',
   ACCT_ITEM_TYPE_ID    numeric(9,0) not null comment '说明该资费对应的帐目类型，在积量类型为金钱时有效',
   INTEGRAL_TYPE_ID     numeric(9,0) comment '积分类型标识',
   SUB_PRODUCT_ID       numeric(9,0) comment '指定该资费标准适用的子产品。在定义一次性费用及循环费用的资费标准时有效。本字段为空时，表示仅适用与主产品。',
   TARIFF_UNIT_ID       numeric(9,0) not null comment '资费标准依靠何种单位进行度量和计算费用，如流量M数、分钟数、秒数等',
   CALC_METHOD_ID       numeric(9,0) not null comment '用于定义执行进行该资费标准的具体计算方法，如直接计算、按日折算等',
   RATE_UNIT            numeric(8,0) not null comment '表示费率是按照每多少个计费单元（即前面定义的"资费单位标识"）进行计价，如每6秒收一笔钱，这个6秒就是计费单元数',
   FIXED_RATE_VALUE_ID  numeric(9,0) not null comment '表示对于每次事件，固定收取的费率',
   SCALED_RATE_VALUE_ID numeric(9,0) not null comment '表示按照前面定义的计算单元数，收取的每单元的费率',
   CALC_PRIORITY        numeric(3,0) not null comment '用于指明在同一个段落下，执行资费标准的优先级，优先级数额小的，将得到优先的执行',
   BELONG_CYCLE_DURATION numeric(5,0) not null comment '说明计算归属的周期所需要的偏移量。',
   CHARGE_PARTY_ID      varchar(3) comment '表示该资费标准向哪个付费方收取费用，例如主叫、被叫、第三方(如帐号)、指定号码等。',
   RESOURCE_OWNER_TYPE  varchar(3) not null comment '当累计量是群内成员共享时，属主对象类型选择群商品实例，否则选择基本商品实例。',
   primary key (TARIFF_ID)
);

alter table USER_PRICING.TARIFF comment '定义了对客户所使用的产品进行计费的基本费用信息，资费标准可分为一次性费用、周期性费用和使用费三种类型。';

/*==============================================================*/
/* Index: I_FKK_TARIFF_CALC_DESC_15                             */
/*==============================================================*/
create index I_FKK_TARIFF_CALC_DESC_15 on USER_PRICING.TARIFF
(
   CALC_METHOD_ID
);

/*==============================================================*/
/* Index: I_FKK_TARIFF_UNIT_16                                  */
/*==============================================================*/
create index I_FKK_TARIFF_UNIT_16 on USER_PRICING.TARIFF
(
   TARIFF_UNIT_ID
);

/*==============================================================*/
/* Index: I_FKK_RATABLE_RESOURCE_17                             */
/*==============================================================*/
create index I_FKK_RATABLE_RESOURCE_17 on USER_PRICING.TARIFF
(
   RESOURCE_ID
);

/*==============================================================*/
/* Index: I_FKK_PRICING_SECTION_18                              */
/*==============================================================*/
create index I_FKK_PRICING_SECTION_18 on USER_PRICING.TARIFF
(
   PRICING_SECTION_ID
);

/*==============================================================*/
/* Index: I_FKK_REF_VALUE_39                                    */
/*==============================================================*/
create index I_FKK_REF_VALUE_39 on USER_PRICING.TARIFF
(
   FIXED_RATE_VALUE_ID
);

/*==============================================================*/
/* Index: I_FKK_REF_VALUE_40                                    */
/*==============================================================*/
create index I_FKK_REF_VALUE_40 on USER_PRICING.TARIFF
(
   SCALED_RATE_VALUE_ID
);

/*==============================================================*/
/* Index: I_FKK_PRODUCT_116                                     */
/*==============================================================*/
create index I_FKK_PRODUCT_116 on USER_PRICING.TARIFF
(
   SUB_PRODUCT_ID
);

/*==============================================================*/
/* Index: I_FKK_ACCT_ITEM_TYPE_117                              */
/*==============================================================*/
create index I_FKK_ACCT_ITEM_TYPE_117 on USER_PRICING.TARIFF
(
   ACCT_ITEM_TYPE_ID
);

/*==============================================================*/
/* Index: I_FKK_ACTION_175                                      */
/*==============================================================*/
create index I_FKK_ACTION_175 on USER_PRICING.TARIFF
(
   ACTION_ID
);

/*==============================================================*/
/* Table: TARIFF_CALC_DESC                                      */
/*==============================================================*/
create table USER_PRICING.TARIFF_CALC_DESC
(
   TARIFF_CALC_ID       numeric(9,0) not null comment '资费计算方法的标识',
   TARIFF_CALC_NAME     varchar(50) not null comment '对该资费计算方法进行具体描述',
   primary key (TARIFF_CALC_ID)
);

alter table USER_PRICING.TARIFF_CALC_DESC comment '用于定义模型所支持的计算资费的计算方法。资费的计算方法是模型所提供的二次开发的重要入口，可以进行扩展，但建议扩展必须在集';

/*==============================================================*/
/* Table: TARIFF_UNIT                                           */
/*==============================================================*/
create table USER_PRICING.TARIFF_UNIT
(
   TARIFF_UNIT_ID       numeric(9,0) not null comment '资费单位的标识',
   MEASURE_METHOD_ID    numeric(9,0) not null comment '该资费单位对应的度量方法，如在长话计费时，秒、分对应的度量方法都是时长',
   TARIFF_UNIT_NAME     varchar(50) not null comment '名称，具体说明该资费单位含义',
   STANDARD_CONVERSION_RATE numeric(12,5) not null comment '指从度量方法的标准单位换算到本单位的比率，比如度量方法为时长，标准单位为秒。如果本单位为分钟，则换算比率为60。',
   primary key (TARIFF_UNIT_ID)
);

alter table USER_PRICING.TARIFF_UNIT comment '表达了一个资费标准依靠何种单位进行度量和计算费用。该表用于记录模型所支持的各种资费单位。如分钟数,流量M数,秒数等。';

/*==============================================================*/
/* Index: I_FKK_MEASURE_METHOD_41                               */
/*==============================================================*/
create index I_FKK_MEASURE_METHOD_41 on USER_PRICING.TARIFF_UNIT
(
   MEASURE_METHOD_ID
);

/*==============================================================*/
/* Table: TIME_PERIOD                                           */
/*==============================================================*/
create table TIME_PERIOD
(
   TIME_PERIOD_ID       numeric(9,0) not null comment '时段信息的唯一标识',
   TIME_PERIOD_NAME     varchar(50) not null comment '时段信息的名称',
   TIME_PERIOD_DESC     varchar(250) not null comment '时段的说明信息。',
   primary key (TIME_PERIOD_ID)
);

alter table TIME_PERIOD comment '时段信息，如：周末、节假日、闲时、忙时等。时段信息的具体内容按需扩展。';

/*==============================================================*/
/* Table: TIME_PERIOD_DEFINE                                    */
/*==============================================================*/
create table TIME_PERIOD_DEFINE
(
   TIME_PERIOD_ID       numeric(9,0) comment '时段信息的唯一标识',
   YEAR                 numeric(4,0),
   MONTH                numeric(2,0) not null,
   DAY                  numeric(2,0),
   DAYOFWEEK            numeric(1,0),
   START_TIME           datetime not null,
   END_TIME             datetime not null,
   primary key (TIME_PERIOD_ID)
);

alter table TIME_PERIOD_DEFINE comment '对时段信息具体的描述，如：周末、节假日、闲时、忙时等。时段信息的具体内容按需扩展。';

/*==============================================================*/
/* Table: TIME_SEGMENT                                          */
/*==============================================================*/
create table USER_PRODUCT.TIME_SEGMENT
(
   TIME_SEGMENT_ID      numeric(9,0) not null comment '帐户群的唯一标识',
   PROVISION_DATE       datetime not null comment '申请该销售品的有效时间，必须在此时间段申请才能享受此销售品',
   ACHIVE_DATE          datetime not null comment '申请该销售品的截止时间，必须在此时间前申请才能享受此销售品',
   ACHIVE_DATE_OFFSET   numeric(5,0) not null comment '申请该销售品的截止时间的相对值，必须在此时间段申请才能享受此销售品',
   ACHIVE_DATE_OFFSET_UNIT numeric(8,0) not null comment '申请该销售品的截止时间的相对值的单位，10A 小时，10B 月 10C 年',
   EFFECTIVE_START_DATE datetime not null comment '销售品生效的绝对时间',
   EFFECTIVE_END_DATE   datetime comment '销售品失效的绝对时间',
   EFF_END_DATE_OFFSET  numeric(5,0) comment '销售品的失效时间，相对于生效时间的相对值',
   EFF_END_DATE_OFFSET_UNIT numeric(8,0) comment '销售品的失效时间相对值的单位，10A 小时 10B 月 10C 年',
   primary key (TIME_SEGMENT_ID)
);

alter table USER_PRODUCT.TIME_SEGMENT comment '销售品的时间限制条件';

/*==============================================================*/
/* Table: TRADE_RECORD                                          */
/*==============================================================*/
create table TRADE_RECORD
(
   SERIAL_NUMBER        varchar(15) not null,
   SEQ_NBR              numeric(5,0) not null,
   PARTY_ID             numeric(9,0) comment '合作伙伴的唯一标识。',
   TRADE_TYPE_ID        numeric(9,0) not null,
   SERV_ID              numeric(12,0) not null,
   AMOUNT               numeric(12,0) not null,
   STATE                varchar(3) not null comment '记录交易过程中的各个状态
            1、交易申请
            2、确认付款
            3、派送（邮寄）确认
            4、收到确实
            5、交易成功
            6、交易失败',
   CREATED_DATE         datetime not null,
   STATE_DATE           datetime not null,
   TRADE_DESC           varchar(250) not null,
   primary key (SERIAL_NUMBER)
);

alter table TRADE_RECORD comment '记录小额支付交易整个过程';

/*==============================================================*/
/* Table: TRADE_TYPE                                            */
/*==============================================================*/
create table TRADE_TYPE
(
   TRADE_TYPE_ID        numeric(9,0) not null,
   TRADE_TYPE_NAME      varchar(50) not null,
   TRADE_YPE_DESC       varchar(250) not null,
   primary key (TRADE_TYPE_ID)
);

alter table TRADE_TYPE comment '对交易事件的分类管理
';

/*==============================================================*/
/* Table: USER_INTEGRAL_RESULT                                  */
/*==============================================================*/
create table USER_ACCT.USER_INTEGRAL_RESULT
(
   USER_INTEGRAL_RESULT_ID numeric(12,0) not null comment '用户积分标识',
   INTEGRAL_TYPE_ID     numeric(9,0) comment '积分类型标识',
   BILLING_CYCLE_ID     numeric(9,0) not null comment '账务周期标识',
   CUST_ID              numeric(12,0) not null comment '客户标识(产权客户)',
   ACCT_ID              numeric(12,0) not null comment '帐户标识(归属帐户)',
   SERV_ID              numeric(12,0) not null comment '用户标识',
   ACC_AMOUNT           numeric(12,0) not null comment '本周期累积积分',
   CREATE_DATE          datetime not null comment '创建时间',
   STATE                varchar(3) not null comment '状态',
   STATE_DATE           datetime not null comment '状态时间',
   primary key (USER_INTEGRAL_RESULT_ID)
);

alter table USER_ACCT.USER_INTEGRAL_RESULT comment '存放用户的实时消费积分,奖励积分';

/*==============================================================*/
/* Table: ZONE                                                  */
/*==============================================================*/
create table USER_PRICING.ZONE
(
   ZONE_ID              numeric(9,0) not null comment '区表的标识',
   PRICING_REF_OBJECT_ID numeric(9,0) comment '参考对象的标识',
   ZONE_NAME            varchar(50) not null comment '该区表的名称',
   primary key (ZONE_ID)
);

alter table USER_PRICING.ZONE comment '区表用于表达一组互相管理的数据，用于把事件的属性值划分成易于管理的类别。如被叫地区、时区、传真分区、Qos分区等都可以做';

/*==============================================================*/
/* Index: I_FKK_PRICING_REF_OBJECT_54                           */
/*==============================================================*/
create index I_FKK_PRICING_REF_OBJECT_54 on USER_PRICING.ZONE
(
   PRICING_REF_OBJECT_ID
);

/*==============================================================*/
/* Table: ZONE_ITEM                                             */
/*==============================================================*/
create table USER_PRICING.ZONE_ITEM
(
   ZONE_ITEM_ID         numeric(9,0) not null comment '区表节点的标识',
   ZONE_ID              numeric(9,0) comment '所属区表标识',
   PARENT_ZONE_ITEM_ID  numeric(9,0) comment '父节点，用于表达层次关系',
   ZONE_ITEM_NAME       varchar(50) not null comment '名称字段，用于详细说明归并后的含义',
   primary key (ZONE_ITEM_ID)
);

alter table USER_PRICING.ZONE_ITEM comment '一个区表可包含多个分区，也可以是个树状的层次分区，区表节点是区表中的一个组成元素。';

/*==============================================================*/
/* Index: I_FKK_ZONE_ITEM_32                                    */
/*==============================================================*/
create index I_FKK_ZONE_ITEM_32 on USER_PRICING.ZONE_ITEM
(
   PARENT_ZONE_ITEM_ID
);

/*==============================================================*/
/* Index: I_FKK_ZONE_33                                         */
/*==============================================================*/
create index I_FKK_ZONE_33 on USER_PRICING.ZONE_ITEM
(
   ZONE_ID
);

/*==============================================================*/
/* Table: ZONE_ITEM_VALUE                                       */
/*==============================================================*/

create table USER_PRICING.ZONE_ITEM_VALUE
(
   ITEM_REF_ID          numeric(9,0) not null comment '区表节点取值的标识',
   ZONE_ITEM_ID         numeric(9,0) not null comment '说明匹配时，对应到哪个区表节点上',
   ITEM_REF_VALUE       varchar(30) not null comment '用于进行归并操作的参考对象取值，即参考对象＝该值时，对应此节点',
   EFF_DATE             datetime not null comment '生效时间',
   EXP_DATE             datetime comment '失效时间',
   primary key (ITEM_REF_ID)
);

alter table USER_PRICING.ZONE_ITEM_VALUE comment '定义在最底层的区表节点上所包含的一组有实际代表意义的数值，如电话号码（区号），IP地址（前缀）等。';

/*==============================================================*/
/* Index: I_FKK_ZONE_ITEM_34                                    */
/*==============================================================*/
create index I_FKK_ZONE_ITEM_34 on USER_PRICING.ZONE_ITEM_VALUE
(
   ZONE_ITEM_ID
);

alter table ACCESSED_CAPABILITY_INFO add constraint FK_Reference_371 foreign key (CAPABILITY_ID)
      references CAPABILITY_INFO (CAPABILITY_ID) on delete restrict on update restrict;

alter table ACCESSED_CAPABILITY_INFO add constraint FK_Reference_372 foreign key (NODE_ID)
      references NODE_INFO (NODE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT add constraint FKK_CUST_152 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_BALANCE add constraint FKK_BALANCE_TYPE_83 foreign key (BALANCE_TYPE_ID)
      references USER_ACCT.BALANCE_TYPE (BALANCE_TYPE_ID) on delete restrict on update restrict;


alter table USER_ACCT.ACCT_BALANCE_LOG add constraint FKK_ACCT_BALANCE_241 foreign key (ACCT_BALANCE_ID)
      references USER_ACCT.ACCT_BALANCE (ACCT_BALANCE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_BALANCE_LOG add constraint FKK_BALANCE_PAYOUT_240 foreign key (OPER_PAYOUT_ID)
      references USER_ACCT.BALANCE_PAYOUT (OPER_PAYOUT_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_BALANCE_LOG add constraint FKK_BALANCE_SOURCE_242 foreign key (OPER_INCOME_ID)
      references USER_ACCT.BALANCE_SOURCE (OPER_INCOME_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_BALANCE_LOG add constraint FKK_BILLING_CYCLE_245 foreign key (BILLING_CYCLE_ID)
      references USER_ACCT.BILLING_CYCLE (BILLING_CYCLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_CREDIT add constraint FKK_ACCT_106 foreign key (ACCT_ID)
      references USER_ACCT.ACCT (ACCT_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM add constraint FKK_ACCT_154 foreign key (ACCT_ID)
      references USER_ACCT.ACCT (ACCT_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM add constraint FKK_ACCT_ITEM_SOURCE_67 foreign key (ITEM_SOURCE_ID)
      references USER_ACCT.ACCT_ITEM_SOURCE (ITEM_SOURCE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM add constraint FKK_ACCT_ITEM_TYPE_61 foreign key (ACCT_ITEM_TYPE_ID)
      references USER_ACCT.ACCT_ITEM_TYPE (ACCT_ITEM_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM add constraint FKK_BILLING_CYCLE_72 foreign key (BILLING_CYCLE_ID)
      references USER_ACCT.BILLING_CYCLE (BILLING_CYCLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM add constraint FKK_BILLING_REGION_347 foreign key (LATN_ID)
      references USER_LOCATION.BILLING_REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM add constraint FKK_BILL_63 foreign key (BILL_ID)
      references USER_ACCT.BILL (BILL_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM add constraint FKK_PAYMENT_METHOD_206 foreign key (PAYMENT_METHOD)
      references USER_ACCT.PAYMENT_METHOD (PAYMENT_METHOD) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM add constraint FKK_SERV_155 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM_ADJUSTED add constraint FKK_ACCT_ITEM_134 foreign key (ADJUST_ACCT_ITEM_ID)
      references USER_ACCT.ACCT_ITEM (ACCT_ITEM_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM_ADJUSTED add constraint FKK_ACCT_ITEM_135 foreign key (ACCT_ITEM_ID)
      references USER_ACCT.ACCT_ITEM (ACCT_ITEM_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM_GROUP_MEMBER add constraint FKK_ACCT_ITEM_GROUP_58 foreign key (ACCT_ITEM_GROUP_ID)
      references USER_ACCT.ACCT_ITEM_GROUP (ACCT_ITEM_GROUP_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM_GROUP_MEMBER add constraint FKK_ACCT_ITEM_SOURCE_66 foreign key (ITEM_SOURCE_ID)
      references USER_ACCT.ACCT_ITEM_SOURCE (ITEM_SOURCE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM_GROUP_MEMBER add constraint FKK_ACCT_ITEM_TYPE_65 foreign key (ACCT_ITEM_TYPE_ID)
      references USER_ACCT.ACCT_ITEM_TYPE (ACCT_ITEM_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM_SOURCE add constraint FKK_ACCT_ITEM_TYPE_70 foreign key (ACCT_ITEM_TYPE_ID)
      references USER_ACCT.ACCT_ITEM_TYPE (ACCT_ITEM_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM_TYPE add constraint FKK_ACCT_ITEM_CLASS_64 foreign key (ACCT_ITEM_CLASS_ID)
      references USER_ACCT.ACCT_ITEM_CLASS (ACCT_ITEM_CLASS_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_ITEM_TYPE add constraint FKK_EMULATORY_PARTNER_199 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.EMULATORY_PARTNER (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_RELATIONSHIP add constraint FKK_ACCT_141 foreign key (ACCT_ID)
      references USER_ACCT.ACCT (ACCT_ID) on delete restrict on update restrict;

alter table USER_ACCT.ACCT_RELATIONSHIP add constraint FKK_ACCT_142 foreign key (REL_ACCT_ID)
      references USER_ACCT.ACCT (ACCT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.ACTION add constraint FKK_ACTION_TYPE_201 foreign key (ACTION_TYPE_ID)
      references USER_PRODUCT.ACTION_TYPE (ACTION_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRICING.AGGREGATE_OBJECT add constraint FKK_PRICING_REF_OBJECT_25 foreign key (BELONG_CALC_OBJECT_ID)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRICING.AGGREGATE_OBJECT add constraint FKK_PRICING_REF_OBJECT_26 foreign key (SUB_CALC_OBJECT_ID)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table PARTY_USER.AGREEMENT add constraint FKK_CUST_151 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.AGREEMENT_ATTR add constraint FKK_AGREEMENT_OBJECT_224 foreign key (AGREEMENT_ID, OBJECT_ID)
      references PARTY_USER.AGREEMENT_OBJECT (AGR_AGREEMENT_ID, OBJECT_ID) on delete restrict on update restrict;

alter table PARTY_USER.AGREEMENT_OBJECT add constraint FKK_AGREEMENT_222 foreign key (AGR_AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table PARTY_USER.AGREEMENT_OBJECT add constraint FKK_AGREEMENT_OBJECT_223 foreign key (AGR_AGREEMENT_ID, PARENT_OBJECT_ID)
      references PARTY_USER.AGREEMENT_OBJECT (AGR_AGREEMENT_ID, OBJECT_ID) on delete restrict on update restrict;

alter table USER_ACCT.APPORTION_RESULT add constraint FKK_SERV_239 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_STAT.ATOM_TREE_STRUCT2 add constraint FKK_ATOM_TREE_348 foreign key (TREE_ID)
      references USER_STAT.ATOM_TREE2 (TREE_ID) on delete restrict on update restrict;

alter table USER_STAT.ATOM_TREE_STRUCT_ITEM2 add constraint FKK_ATOM_TREE_STRUCT_360 foreign key (TREE_NODE_ID)
      references USER_STAT.ATOM_TREE_STRUCT2 (TREE_NODE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_ACCT_ITEM_PAYED add constraint FKK_ACCT_ITEM_221 foreign key (ACCT_ITEM_ID)
      references USER_ACCT.ACCT_ITEM (ACCT_ITEM_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_ACCT_ITEM_PAYED add constraint FKK_BALANCE_PAYOUT_226 foreign key (OPER_PAYOUT_ID)
      references USER_ACCT.BALANCE_PAYOUT (OPER_PAYOUT_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_PAYOUT add constraint FKK_ACCT_BALANCE_218 foreign key (ACCT_BALANCE_ID)
      references USER_ACCT.ACCT_BALANCE (ACCT_BALANCE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_PAYOUT add constraint FKK_BALANCE_RELATION_247 foreign key (BALANCE_RELATION_ID)
      references USER_ACCT.BALANCE_RELATION (BALANCE_RELATION_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_PAYOUT add constraint FKK_BILLING_CYCLE_219 foreign key (BILLING_CYCLE_ID)
      references USER_ACCT.BILLING_CYCLE (BILLING_CYCLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_PAYOUT add constraint FKK_BILL_220 foreign key (BILL_ID)
      references USER_ACCT.BILL (BILL_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_PRESENT_RULE add constraint FKK_BALANCE_TYPE_295 foreign key (PAY_BALANCE_TYPE_ID)
      references USER_ACCT.BALANCE_TYPE (BALANCE_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_PRESENT_RULE add constraint FKK_BALANCE_TYPE_296 foreign key (PRESENT_BALANCE_TYPE_ID)
      references USER_ACCT.BALANCE_TYPE (BALANCE_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_RELATION add constraint FKK_ACCT_BALANCE_84 foreign key (ACCT_BALANCE_ID)
      references USER_ACCT.ACCT_BALANCE (ACCT_BALANCE_ID) on delete restrict on update restrict;

alter table BALANCE_RESERVE_DETAIL add constraint FK_Reference_424 foreign key (ACCT_BALANCE_ID)
      references USER_ACCT.ACCT_BALANCE (ACCT_BALANCE_ID) on delete restrict on update restrict;

alter table BALANCE_RESERVE_DETAIL add constraint FK_Reference_425 foreign key (SERIAL_NUMBER)
      references TRADE_RECORD (SERIAL_NUMBER) on delete restrict on update restrict;

alter table BALANCE_RESERVE_DETAIL add constraint FK_Reference_428 foreign key (OPER_PAYOUT_ID)
      references USER_ACCT.BALANCE_PAYOUT (OPER_PAYOUT_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_SHARE_RULE add constraint FKK_ACCT_BALANCE_243 foreign key (ACCT_BALANCE_ID)
      references USER_ACCT.ACCT_BALANCE (ACCT_BALANCE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_SHARE_RULE add constraint FKK_SHARE_RULE_TYPE_244 foreign key (SHARE_RULE_TYPE_ID)
      references USER_ACCT.SHARE_RULE_TYPE (SHARE_RULE_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_SOURCE add constraint FKK_ACCT_BALANCE_217 foreign key (ACCT_BALANCE_ID)
      references USER_ACCT.ACCT_BALANCE (ACCT_BALANCE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_SOURCE add constraint FKK_BALANCE_RELATION_246 foreign key (BALANCE_RELATION_ID)
      references USER_ACCT.BALANCE_RELATION (BALANCE_RELATION_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_SOURCE add constraint FKK_BALANCE_SOURCE_TYPE_248 foreign key (BALANCE_SOURCE_ID)
      references USER_ACCT.BALANCE_SOURCE_TYPE (BALANCE_SOURCE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_TYPE add constraint FKK_MEASURE_METHOD_294 foreign key (MEASURE_METHOD_ID)
      references USER_PRICING.MEASURE_METHOD (MEASURE_METHOD_ID) on delete restrict on update restrict;

alter table USER_ACCT.BALANCE_TYPE add constraint FKK_SPECIAL_PAYMENT_DESC_79 foreign key (SPE_PAYMENT_ID)
      references USER_ACCT.SPECIAL_PAYMENT_DESC (SPE_PAYMENT_ID) on delete restrict on update restrict;

alter table USER_PRICING.BALANCE_TYPE_PARAM add constraint FK_Reference_385 foreign key (BALANCE_TYPE_ID)
      references USER_ACCT.BALANCE_TYPE (BALANCE_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.BAND add constraint FKK_BAND_267 foreign key (BAN_BAND_ID)
      references USER_PRODUCT.BAND (BAND_ID) on delete restrict on update restrict;

alter table USER_ACCT.BANK_BRANCH add constraint FKK_BANK_140 foreign key (BANK_ID)
      references USER_ACCT.BANK (BANK_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL add constraint FKK_ACCT_150 foreign key (ACCT_ID)
      references USER_ACCT.ACCT (ACCT_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL add constraint FKK_BILLING_CYCLE_73 foreign key (BILLING_CYCLE_ID)
      references USER_ACCT.BILLING_CYCLE (BILLING_CYCLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL add constraint FKK_PAYMENT_62 foreign key (PAYMENT_ID)
      references USER_ACCT.PAYMENT (PAYMENT_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL add constraint FKK_PAYMENT_METHOD_121 foreign key (PAYMENT_METHOD)
      references USER_ACCT.PAYMENT_METHOD (PAYMENT_METHOD) on delete restrict on update restrict;

alter table USER_ACCT.BILL add constraint FKK_SERV_149 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL add constraint FKK_STAFF_148 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.STAFF (STAFF_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILLING_CYCLE add constraint FKK_BILLING_CYCLE_143 foreign key (LAST_BILLING_CYCLE_ID)
      references USER_ACCT.BILLING_CYCLE (BILLING_CYCLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILLING_CYCLE add constraint FKK_BILLING_CYCLE_TYPE_115 foreign key (BILLING_CYCLE_TYPE_ID)
      references USER_ACCT.BILLING_CYCLE_TYPE (BILLING_CYCLE_TYPE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.BILLING_REGION add constraint FKK_BILLING_REGION_105 foreign key (PARENT_REGION_ID)
      references USER_LOCATION.BILLING_REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_LOCATION.BILLING_REGION add constraint FKK_REGION_335 foreign key (REGION_ID)
      references USER_LOCATION.REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_ACCT_ITEM add constraint FKK_ACCT_ITEM_SOURCE_69 foreign key (ITEM_SOURCE_ID)
      references USER_ACCT.ACCT_ITEM_SOURCE (ITEM_SOURCE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_ACCT_ITEM add constraint FKK_ACCT_ITEM_TYPE_68 foreign key (ACCT_ITEM_TYPE_ID)
      references USER_ACCT.ACCT_ITEM_TYPE (ACCT_ITEM_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_ACCT_ITEM add constraint FKK_BILL_ITEM_59 foreign key (BILL_ITEM_TYPE_ID)
      references USER_ACCT.BILL_ITEM (BILL_ITEM_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_FORMAT add constraint FKK_BILL_REMARK_123 foreign key (BILL_REMARK_ID)
      references USER_ACCT.BILL_REMARK (BILL_REMARK_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_FORMAT_CUSTOMIZE add constraint FKK_ADDRESS_289 foreign key (ADDRESS_ID)
      references USER_LOCATION.ADDRESS (ADDRESS_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_FORMAT_CUSTOMIZE add constraint FKK_BILL_FORMAT_292 foreign key (BILL_FORMAT_ID)
      references USER_ACCT.BILL_FORMAT (BILL_FORMAT_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_FORMAT_ITEM add constraint FKK_BILL_FORMAT_132 foreign key (BILL_FORMAT_ID)
      references USER_ACCT.BILL_FORMAT (BILL_FORMAT_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_FORMAT_ITEM add constraint FKK_BILL_ITEM_60 foreign key (BILL_ITEM_TYPE_ID)
      references USER_ACCT.BILL_ITEM (BILL_ITEM_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_FORMAT_SELECTOR add constraint FKK_BILL_FORMAT_293 foreign key (BILL_FORMAT_ID)
      references USER_ACCT.BILL_FORMAT (BILL_FORMAT_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_FORMAT_SELECTOR add constraint FKK_BILL_FORMAT_CUSTOMIZE_291 foreign key (BILL_FORMAT_CUSTOMIZE_ID)
      references USER_ACCT.BILL_FORMAT_CUSTOMIZE (BILL_FORMAT_CUSTOMIZE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_ITEM add constraint FKK_BILL_ITEM_55 foreign key (BILL_PARENT_ID)
      references USER_ACCT.BILL_ITEM (BILL_ITEM_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_ITEM add constraint FKK_BILL_REMARK_125 foreign key (BILL_REMARK_ID)
      references USER_ACCT.BILL_REMARK (BILL_REMARK_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_ITEM add constraint FKK_PRODUCT_OFFER_285 foreign key (PRODUCT_OFFER_ID)
      references USER_PRODUCT.PRODUCT_OFFER (OFFER_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_RECORD add constraint FKK_BILL_FORMAT_CUSTOMIZE_290 foreign key (BILL_FORMAT_CUSTOMIZE_ID)
      references USER_ACCT.BILL_FORMAT_CUSTOMIZE (BILL_FORMAT_CUSTOMIZE_ID) on delete restrict on update restrict;

alter table USER_ACCT.BILL_REMARK add constraint FKK_BILL_VARIABLE_124 foreign key (BILL_VARIABLE_ID)
      references USER_ACCT.BILL_VARIABLE (BILL_VARIABLE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.BORDER_ROAMING_REGION add constraint FK_Reference_373 foreign key (REGION_ID)
      references USER_LOCATION.REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_LOCATION.BORDER_ROAMING_REGION add constraint FK_Reference_411 foreign key (CELL_INFO_ID)
      references USER_LOCATION.CELL_INFO (CELL_INFO_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.CATALOG_ITEM add constraint FKK_BAND_258 foreign key (BAND_ID)
      references USER_PRODUCT.BAND (BAND_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.CATALOG_ITEM add constraint FKK_CATALOG_177 foreign key (CATALOG_ID)
      references USER_PRODUCT.CATALOG (CATALOG_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.CATALOG_ITEM add constraint FKK_CATALOG_ITEM_178 foreign key (PARENT_CATALOG_ITEM_ID)
      references USER_PRODUCT.CATALOG_ITEM (CATALOG_ITEM_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.CATALOG_ITEM_ELEMENT add constraint FKK_CATALOG_ITEM_176 foreign key (CATALOG_ITEM_ID)
      references USER_PRODUCT.CATALOG_ITEM (CATALOG_ITEM_ID) on delete restrict on update restrict;

alter table CC_BUSINESS_TYPE add constraint FK_Reference_414 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table CC_PLAN_INSTANCE_RELATION add constraint FK_Reference_400 foreign key (CC_PLAN_ID)
      references CC_PLAN (CC_PLAN_ID) on delete restrict on update restrict;



alter table USER_ACCT.CC_PLAN_OBJECT add constraint FK_Reference_402 foreign key (OFFER_ID)
      references USER_PRODUCT.PRODUCT_OFFER (OFFER_ID) on delete restrict on update restrict;

alter table USER_ACCT.CC_PLAN_OBJECT add constraint FK_Reference_403 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table USER_ACCT.CC_PLAN_OBJECT add constraint FK_Reference_404 foreign key (REGION_ID)
      references USER_LOCATION.BILLING_REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_ACCT.CC_PLAN_OBJECT add constraint FK_Reference_405 foreign key (CREDIT_GRADE_ID)
      references PARTY_USER.CREDIT_GRADE (CREDIT_GRADE_ID) on delete restrict on update restrict;

alter table USER_ACCT.CC_PLAN_OBJECT add constraint FK_Reference_406 foreign key (BAND_ID)
      references USER_PRODUCT.BAND (BAND_ID) on delete restrict on update restrict;

alter table CC_STRATEGY add constraint FK_Reference_412 foreign key (CC_PLAN_ID)
      references CC_PLAN (CC_PLAN_ID) on delete restrict on update restrict;

alter table CC_STRATEGY add constraint FK_Reference_413 foreign key (CC_BUSINESS_TYPE_ID)
      references CC_BUSINESS_TYPE (CC_BUSINESS_TYPE_ID) on delete restrict on update restrict;

alter table CC_STRATEGY add constraint FK_Reference_419 foreign key (CC_TYPE_GROUP_ID)
      references CC_BUSINESS_TYPE_GROUP (CC_TYPE_GROUP_ID) on delete restrict on update restrict;

alter table CC_STRATEGY add constraint FK_Reference_420 foreign key (CC_OBJECT_EXINFO_ID)
      references CC_OBJECT_EXINFO (CC_OBJECT_EXINFO_ID) on delete restrict on update restrict;

alter table CC_STRATEGY add constraint FK_Reference_421 foreign key (TIME_PERIOD_ID)
      references TIME_PERIOD (TIME_PERIOD_ID) on delete restrict on update restrict;

alter table CC_STRATEGY add constraint FK_Reference_422 foreign key (PRICING_RULE_ID)
      references USER_PRICING.PRICING_RULE (PRICING_RULE_ID) on delete restrict on update restrict;

alter table CC_TYPE_GROUP_MEMBER add constraint FK_Reference_415 foreign key (CC_TYPE_GROUP_ID)
      references CC_BUSINESS_TYPE_GROUP (CC_TYPE_GROUP_ID) on delete restrict on update restrict;

alter table CC_TYPE_GROUP_MEMBER add constraint FK_Reference_418 foreign key (CC_BUSINESS_TYPE_ID)
      references CC_BUSINESS_TYPE (CC_BUSINESS_TYPE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.CELL_INFO add constraint FK_Reference_407 foreign key (CELL_INFO_ID)
      references USER_LOCATION.EQUIP (EQUIP_ID) on delete restrict on update restrict;

alter table USER_LOCATION.CELL_INFO add constraint FK_Reference_408 foreign key (REGION_ID)
      references USER_LOCATION.BILLING_REGION (REGION_ID) on delete restrict on update restrict;

alter table PARTY_USER.CHANNEL_SEGMENT add constraint FKK_PARTNER_111 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.PARTNER (PARTY_ID) on delete restrict on update restrict;

alter table USER_ACCT.CHARGE_ADJUST_LOG add constraint FKK_ACCT_ITEM_ADJUSTED_87 foreign key (ACCT_ITEM_ID)
      references USER_ACCT.ACCT_ITEM_ADJUSTED (ADJUST_RECORD_ID) on delete restrict on update restrict;

alter table USER_ACCT.CHARGE_ADJUST_LOG add constraint FKK_STAFF_136 foreign key (STAFF_ID)
      references PARTY_USER.STAFF (STAFF_ID) on delete restrict on update restrict;

alter table PARTY_USER.CONTACT_MEDIUM add constraint FKK_ADDRESS_104 foreign key (ADDRESS_ID)
      references USER_LOCATION.ADDRESS (ADDRESS_ID) on delete restrict on update restrict;

alter table PARTY_USER.CONTACT_MEDIUM add constraint FKK_PARTY_ROLE_187 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.PARTY_ROLE (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table PARTY_USER.CONTACT_MEDIUM add constraint FKK_POLITICAL_REGION_339 foreign key (REGION_ID)
      references USER_LOCATION.POLITICAL_REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.CONTENT_CLASS add constraint FKK_CONTENT_CLASS_255 foreign key (PARENT_CLASS_ID)
      references USER_PRODUCT.CONTENT_CLASS (CLASS_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.CONTENT_CLASS add constraint FKK_PRODUCT_256 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table PARTY_USER.CREDIT_GRADE_RULE add constraint FKK_CREDIT_GRADE_276 foreign key (CREDIT_GRADE_ID)
      references PARTY_USER.CREDIT_GRADE (CREDIT_GRADE_ID) on delete restrict on update restrict;

alter table PARTY_USER.CREDIT_RESULT add constraint FKK_CREDIT_GRADE_275 foreign key (CREDIT_GRADE_ID)
      references PARTY_USER.CREDIT_GRADE (CREDIT_GRADE_ID) on delete restrict on update restrict;

alter table PARTY_USER.CREDIT_RESULT_DETAIL add constraint FKK_EVAL_RULE_278 foreign key (EVAL_RULE_ID)
      references PARTY_USER.EVAL_RULE (EVAL_RULE_ID) on delete restrict on update restrict;

alter table PARTY_USER.CREDIT_VALUE add constraint FK_Reference_367 foreign key (CREDIT_VALUE_RULE_ID)
      references PARTY_USER.CREDIT_VALUE_RULE (CREDIT_VALUE_RULE_ID) on delete restrict on update restrict;

alter table PARTY_USER.CREDIT_VALUE add constraint FK_Reference_368 foreign key (CREDIT_VALUE_TYPE_ID)
      references PARTY_USER.CREDIT_VALUE_TYPE (CREDIT_VALUE_TYPE_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST add constraint FKK_PARTY_ROLE_300 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.PARTY_ROLE (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST add constraint FK_Reference_366 foreign key (CUST_BAND_ID)
      references USER_PRODUCT.BAND (BAND_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST add constraint FK_Reference_384 foreign key (CUST_TYPE_ID)
      references PARTY_USER.CUST_TYPE (CUST_TYPE_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_ADD_INFO add constraint FKK_AGREEMENT_173 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_ADD_INFO add constraint FKK_CUST_98 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_ADD_INFO add constraint FKK_CUST_ADD_INFO_ITEM_169 foreign key (INFO_ID)
      references PARTY_USER.CUST_ADD_INFO_ITEM (ASS_INFO_ITEM_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_CONTACT_INFO add constraint FKK_AGREEMENT_172 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_CONTACT_INFO add constraint FKK_CUST_99 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_CORPORATE_INFO add constraint FKK_AGREEMENT_171 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_CORPORATE_INFO add constraint FKK_CUST_96 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_CORPORATE_INFO add constraint FKK_INDUSTRY_209 foreign key (INDUSTRY_ID)
      references PARTY_USER.INDUSTRY (INDUSTRY_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_CREDIT add constraint FKK_CUST_179 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_CREDIT_RECORD add constraint FKK_CUST_97 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_GROUP_MEMBER add constraint FKK_CUST_109 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_GROUP_MEMBER add constraint FKK_CUST_GROUP_110 foreign key (CUST_GROUP_ID)
      references PARTY_USER.CUST_GROUP (CUST_GROUP_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_IDENTIFICATION add constraint FKK_CUST_100 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_INTERACTION add constraint FKK_CUST_95 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_INTERACTION_DETAIL add constraint FKK_CUST_INTERACTION_166 foreign key (CUST_INTERACTION_ID)
      references PARTY_USER.CUST_INTERACTION (CUST_INTERACTION_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_INTERACTION_DETAIL add constraint FKK_CUST_INTERACTION_ITEM_167 foreign key (INTERACTION_ITEM_ID)
      references PARTY_USER.CUST_INTERACTION_ITEM (INTERACTION_ITEM_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_LOYALTY_RECORD add constraint FKK_CUST_168 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_PERSON_INFO add constraint FKK_AGREEMENT_170 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_PERSON_INFO add constraint FKK_CUST_101 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table PARTY_USER.CUST_PERSON_INFO add constraint FKK_INDUSTRY_208 foreign key (INDUSTRY_ID)
      references PARTY_USER.INDUSTRY (INDUSTRY_ID) on delete restrict on update restrict;

alter table USER_EVENT.DEST_EVENT_FORMAT add constraint FKK_DEST_EVENT_TYPE_312 foreign key (EVENT_TYPE_ID)
      references USER_EVENT.DEST_EVENT_TYPE (EVENT_TYPE_ID) on delete restrict on update restrict;

alter table USER_EVENT.DEST_EVENT_FORMAT_ITEM add constraint FKK_DEST_EVENT_FORMAT_311 foreign key (EVENT_FORMAT_ID)
      references USER_EVENT.DEST_EVENT_FORMAT (EVENT_FORMAT_ID) on delete restrict on update restrict;

alter table USER_EVENT.DEST_EVENT_FORMAT_ITEM add constraint FKK_EVENT_ATTR_313 foreign key (EVENT_ATTR_ID)
      references USER_EVENT.EVENT_ATTR (EVENT_ATTR_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_CALC_OBJECT add constraint FKK_DISCOUNT_EXPRESS_36 foreign key (DISCONT_EXPRESS_ID)
      references USER_PRICING.DISCOUNT_EXPRESS (DISCOUNT_EXPRESS_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_CALC_OBJECT add constraint FKK_PRICING_REF_OBJECT_37 foreign key (PRICING_REF_OBJECT_ID)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_EXPRESS add constraint FKK_DISCOUNT_METHOD_27 foreign key (DISCOUNT_METHOD_ID)
      references USER_PRICING.DISCOUNT_METHOD (DISCOUNT_METHOD_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_EXPRESS add constraint FKK_PRICING_SECTION_49 foreign key (PRICING_SECTION_ID)
      references USER_PRICING.PRICING_SECTION (PRICING_SECTION_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_EXPRESS add constraint FKK_RATABLE_RESOURCE_50 foreign key (RATABLE_RESOURCE_ID)
      references USER_PRICING.RATABLE_RESOURCE (RATABLE_RESOURCE_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_EXPRESS add constraint FKK_REF_VALUE_230 foreign key (END_REF_VALUE_ID)
      references USER_PRICING.REF_VALUE (REF_VALUE_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_EXPRESS add constraint FKK_REF_VALUE_231 foreign key (START_REF_VALUE_ID)
      references USER_PRICING.REF_VALUE (REF_VALUE_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_EXPRESS add constraint FK_Reference_433 foreign key (INTEGRAL_TYPE_ID)
      references USER_PRICING.INTEGRAL_TYPE (INTEGRAL_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_REPATITION_TYPE add constraint FKK_PRICING_REF_OBJECT_227 foreign key (PRICING_REF_OBJECT_ID)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_TARGET_OBJECT add constraint FKK_DISCOUNT_EXPRESS_46 foreign key (DISCOUNT_EXPRESS_ID)
      references USER_PRICING.DISCOUNT_EXPRESS (DISCOUNT_EXPRESS_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_TARGET_OBJECT add constraint FKK_DISCOUNT_REPATITION_T_48 foreign key (REPATITION_TYPE_ID)
      references USER_PRICING.DISCOUNT_REPATITION_TYPE (REPATITION_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_TARGET_OBJECT add constraint FKK_PRICING_REF_OBJECT_47 foreign key (PRICING_REF_OBJECT_ID)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_TIME_LIMIT add constraint FKK_DISCOUNT_EXPRESS_28 foreign key (DISCOUNT_EXPRESS_ID)
      references USER_PRICING.DISCOUNT_EXPRESS (DISCOUNT_EXPRESS_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_TIME_LIMIT add constraint FKK_PRICING_REF_OBJECT_29 foreign key (BEGIN_CALC_OBJECT)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRICING.DISCOUNT_TIME_LIMIT add constraint FKK_PRICING_REF_OBJECT_30 foreign key (END_CALC_OBJECT)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table PARTY_USER.EMULATORY_PARTNER add constraint FKK_PARTY_ROLE_185 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.PARTY_ROLE (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.EQUIP add constraint FKK_EQUIP_TYPE_329 foreign key (EQUIP_TYPE_ID)
      references USER_LOCATION.EQUIP_TYPE (EQUIP_TYPE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.EQUIP_REGION add constraint FKK_EQUIP_328 foreign key (EQUIP_ID)
      references USER_LOCATION.EQUIP (EQUIP_ID) on delete restrict on update restrict;

alter table USER_LOCATION.EQUIP_REGION add constraint FKK_REGION_337 foreign key (REGION_ID)
      references USER_LOCATION.REGION (REGION_ID) on delete restrict on update restrict;

alter table PARTY_USER.EVAL_RULE add constraint FKK_EVAL_INDEX_280 foreign key (TARGET_ID)
      references PARTY_USER.EVAL_INDEX (TARGET_ID) on delete restrict on update restrict;

alter table PARTY_USER.EVAL_RULE add constraint FKK_EVAL_PLAN_274 foreign key (EVAL_PLAN_ID)
      references PARTY_USER.EVAL_PLAN (EVAL_PLAN_ID) on delete restrict on update restrict;

alter table USER_EVENT.EVENT_CONTENT add constraint FKK_EVENT_ATTR_303 foreign key (EVENT_ATTR_ID)
      references USER_EVENT.EVENT_ATTR (EVENT_ATTR_ID) on delete restrict on update restrict;

alter table USER_EVENT.EVENT_CONTENT add constraint FKK_EVENT_CONTENT_INDEX_302 foreign key (EVENT_CONTENT_ID)
      references USER_EVENT.EVENT_CONTENT_INDEX (EVENT_CONTENT_ID) on delete restrict on update restrict;

alter table USER_PRICING.EVENT_PRICING_STRATEGY add constraint FKK_DEST_EVENT_TYPE_321 foreign key (EVENT_TYPE_ID)
      references USER_EVENT.DEST_EVENT_TYPE (EVENT_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.EXTERNAL_PRODUCT add constraint FKK_PARTY_ROLE_203 foreign key (PRODUCT_PROVIDER_ID)
      references PARTY_USER.PARTY_ROLE (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_STAT.EXTERNAL_STATS2 add constraint FKK_EXTERNAL_TREE_STRUCT_359 foreign key (EXTERNAL_TREE_NODE_ID)
      references USER_STAT.EXTERNAL_TREE_STRUCT2 (EXTERNAL_TREE_NODE_ID) on delete restrict on update restrict;

alter table USER_STAT.EXTERNAL_TREE_STRUCT2 add constraint FKK_TARGET_TREE_353 foreign key (EXTERNAL_TREE_ID)
      references USER_STAT.TARGET_TREE2 (TARGET_TREE_ID) on delete restrict on update restrict;

alter table USER_STAT.FACT_TABLE_COLUMN2 add constraint FKK_FACT_TABLE_DEFINE_351 foreign key (FACT_TABLE_ID)
      references USER_STAT.FACT_TABLE_DEFINE2 (FACT_TABLE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.GROUP_INSTANCE_MEMBER add constraint FKK_GROUP_INSTANCE_270 foreign key (GROUP_ID)
      references USER_PRODUCT.GROUP_INSTANCE (GROUP_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.GROUP_INSTANCE_MEMBER add constraint FKK_GROUP_INSTANCE_ROLE_263 foreign key (MEMBER_ROLE_ID)
      references USER_PRODUCT.GROUP_INSTANCE_ROLE (MEMBER_ROLE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.GROUP_INSTANCE_MEMBER add constraint FKK_GROUP_MEMBER_TYPE_262 foreign key (MEMBER_TYPE_ID)
      references USER_PRODUCT.GROUP_MEMBER_TYPE (MEMBER_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.GROUP_INSTANCE_MEMBER add constraint FKK_LIFE_CYCLE_271 foreign key (LIFE_CYCLE_ID)
      references USER_PRICING.LIFE_CYCLE (LIFE_CYCLE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.GROUP_INSTANCE_MEMBER add constraint FKK_SERV_264 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table GROUP_MEMBER_RELATION add constraint FK_Reference_416 foreign key (GROUP_MEMBER_A)
      references GROUP_PRODUCT_DETAIL (GROUP_MEMBER_ID) on delete restrict on update restrict;

alter table GROUP_MEMBER_RELATION add constraint FK_Reference_417 foreign key (GROUP_MEMBER_Z)
      references GROUP_PRODUCT_DETAIL (GROUP_MEMBER_ID) on delete restrict on update restrict;

alter table GROUP_PRODUCT_DETAIL add constraint FK_Reference_387 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table GROUP_PRODUCT_DETAIL add constraint FK_Reference_390 foreign key (GROUP_ROLE_ID)
      references GROUP_ROLE (GROUP_ROLE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.HCODE add constraint FKK_EMULATORY_PARTNER_330 foreign key (EMULATORY_PARTNER_ID)
      references PARTY_USER.EMULATORY_PARTNER (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.HCODE add constraint FKK_POLITICAL_REGION_326 foreign key (POLITICAL_REGION_ID)
      references USER_LOCATION.POLITICAL_REGION (REGION_ID) on delete restrict on update restrict;

alter table IDEP_INFO add constraint FK_Reference_370 foreign key (SC_ID)
      references SC_INFO (SC_ID) on delete restrict on update restrict;

alter table IDEP_INFO add constraint FK_Reference_430 foreign key (REGION_ID)
      references USER_LOCATION.REGION (REGION_ID) on delete restrict on update restrict;

alter table PARTY_USER.INDIVIDUAL add constraint FKK_PARTY_181 foreign key (INDIVIDUAL_ID)
      references PARTY_USER.PARTY (PARTY_ID) on delete restrict on update restrict;

alter table PARTY_USER.INTEGRAL_REAULT_DETAIL add constraint FKK_EVAL_RULE_277 foreign key (EVAL_RULE_ID)
      references PARTY_USER.EVAL_RULE (EVAL_RULE_ID) on delete restrict on update restrict;

alter table USER_PRICING.INTEGRAL_TYPE add constraint FK_Reference_436 foreign key (USER_INTEGRAL_RESULT_ID)
      references USER_ACCT.USER_INTEGRAL_RESULT (USER_INTEGRAL_RESULT_ID) on delete restrict on update restrict;

alter table USER_STAT.INTERNAL_STRUCT_ITEM2 add constraint FKK_INTERNAL_TREE_STRUCT_355 foreign key (INTERNAL_TREE_NODE_ID)
      references USER_STAT.INTERNAL_TREE_STRUCT2 (INTERNAL_TREE_NODE_ID) on delete restrict on update restrict;

alter table USER_STAT.INTERNAL_TREE_STRUCT2 add constraint FKK_ATOM_TREE_STRUCT_358 foreign key (ATOM_TREE_NODE_ID)
      references USER_STAT.ATOM_TREE_STRUCT2 (TREE_NODE_ID) on delete restrict on update restrict;

alter table USER_STAT.INTERNAL_TREE_STRUCT2 add constraint FKK_FACT_TABLE_DEFINE_362 foreign key (FACT_TABLE_ID)
      references USER_STAT.FACT_TABLE_DEFINE2 (FACT_TABLE_ID) on delete restrict on update restrict;

alter table USER_STAT.INTERNAL_TREE_STRUCT2 add constraint FKK_TARGET_TREE_352 foreign key (INTERNAL_TREE_ID)
      references USER_STAT.TARGET_TREE2 (TARGET_TREE_ID) on delete restrict on update restrict;

alter table USER_ACCT.INVOICE add constraint FKK_BILLING_CYCLE_74 foreign key (BILLING_CYCLE_ID)
      references USER_ACCT.BILLING_CYCLE (BILLING_CYCLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.INVOICE add constraint FKK_BILL_FORMAT_CUSTOMIZE_288 foreign key (BILL_FORMAT_CUSTOMIZE_ID)
      references USER_ACCT.BILL_FORMAT_CUSTOMIZE (BILL_FORMAT_CUSTOMIZE_ID) on delete restrict on update restrict;

alter table USER_ACCT.INVOICE add constraint FKK_PAYMENT_75 foreign key (PAYMENT_ID)
      references USER_ACCT.PAYMENT (PAYMENT_ID) on delete restrict on update restrict;

alter table USER_ACCT.INVOICE add constraint FKK_STAFF_146 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.STAFF (STAFF_ID) on delete restrict on update restrict;

alter table USER_ACCT.INVOICE_DETAIL add constraint FKK_INVOICE_284 foreign key (INVOICE_ID)
      references USER_ACCT.INVOICE (INVOICE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.LOCAL_HEAD add constraint FKK_BILLING_REGION_325 foreign key (EXCHANGE_ID)
      references USER_LOCATION.BILLING_REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_LOCATION.LOCAL_HEAD add constraint FKK_EMULATORY_PARTNER_332 foreign key (EMULATORY_PARTNER_ID)
      references PARTY_USER.EMULATORY_PARTNER (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.LOGICAL_ADDRESS add constraint FKK_ADDRESS_180 foreign key (ADDRESS_ID)
      references USER_LOCATION.ADDRESS (ADDRESS_ID) on delete restrict on update restrict;

alter table USER_STAT.MID_ID_DEFINE2 add constraint FKK_KEY_ID_DEFINE_349 foreign key (KEY_ID)
      references USER_STAT.KEY_ID_DEFINE2 (KEY_ID) on delete restrict on update restrict;

alter table USER_STAT.MID_ID_DEFINE2 add constraint FKK_MID_TABLE_DEFINE_361 foreign key (MID_TABLE_ID)
      references USER_STAT.MID_TABLE_DEFINE2 (MID_TABLE_ID) on delete restrict on update restrict;

alter table USER_STAT.MID_TABLE_COLUMN2 add constraint FKK_MID_TABLE_DEFINE_350 foreign key (MID_TABLE_ID)
      references USER_STAT.MID_TABLE_DEFINE2 (MID_TABLE_ID) on delete restrict on update restrict;

alter table MIN_INFO add constraint FK_Reference_409 foreign key (REGION_ID)
      references USER_LOCATION.POLITICAL_REGION (REGION_ID) on delete restrict on update restrict;

alter table MIN_INFO add constraint FK_Reference_410 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.EMULATORY_PARTNER (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table NODE_INFO add constraint FK_Reference_368 foreign key (LICENSE_ID)
      references LICENSE (LICENSE_ID) on delete restrict on update restrict;

alter table NODE_INFO add constraint FK_Reference_369 foreign key (IDEP_ID)
      references IDEP_INFO (IDEP_ID) on delete restrict on update restrict;

alter table NODE_INFO add constraint FK_Reference_429 foreign key (REGION_ID)
      references USER_LOCATION.REGION (REGION_ID) on delete restrict on update restrict;

alter table OCS_RESERVE_EVENT_GRP_MEMBER add constraint FK_Reference_3 foreign key (EVT_TYPE_GRP_ID)
      references OCS_RESERVE_EVENT_GRP (EVT_TYPE_GRP_ID) on delete restrict on update restrict;

alter table OCS_RESERVE_EVENT_GRP_MEMBER add constraint FK_Reference_382 foreign key (EVENT_TYPE_ID)
      references USER_EVENT.DEST_EVENT_TYPE (EVENT_TYPE_ID) on delete restrict on update restrict;

alter table OCS_RESERVE_LIMIT add constraint FK_Reference_2 foreign key (EVT_TYPE_GRP_ID)
      references OCS_RESERVE_EVENT_GRP (EVT_TYPE_GRP_ID) on delete restrict on update restrict;

alter table OCS_RESERVE_POLICY add constraint FK_Reference_1 foreign key (EVT_TYPE_GRP_ID)
      references OCS_RESERVE_EVENT_GRP (EVT_TYPE_GRP_ID) on delete restrict on update restrict;

alter table PARTY_USER.ORGANIZATION add constraint FKK_ORGANIZATION_183 foreign key (PARENT_ORGID)
      references PARTY_USER.ORGANIZATION (ORG_ID) on delete restrict on update restrict;

alter table PARTY_USER.ORGANIZATION add constraint FKK_PARTY_182 foreign key (ORG_ID)
      references PARTY_USER.PARTY (PARTY_ID) on delete restrict on update restrict;

alter table PARTY_USER.ORGANIZATION add constraint FKK_REGION_338 foreign key (REGION_ID)
      references USER_LOCATION.REGION (REGION_ID) on delete restrict on update restrict;

alter table PARTY_USER.PARTNER add constraint FKK_PARTY_ROLE_186 foreign key (PARTY_ID)
      references PARTY_USER.PARTY_ROLE (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.PARTNER_ACCT_ITEM add constraint FK_Reference_386 foreign key (ACCT_ITEM_ID)
      references USER_ACCT.ACCT_ITEM (ACCT_ITEM_ID) on delete restrict on update restrict;

alter table PARTY_USER.PARTNER_AGREEMENT add constraint FKK_PARTNER_283 foreign key (PARTNER_ID)
      references PARTY_USER.PARTNER (PARTY_ID) on delete restrict on update restrict;

alter table PARTY_USER.PARTY_IDENTIFICATION add constraint FKK_PARTY_102 foreign key (PARTY_ID)
      references PARTY_USER.PARTY (PARTY_ID) on delete restrict on update restrict;

alter table PARTY_USER.PARTY_ROLE add constraint FKK_PARTY_188 foreign key (PARTY_ID)
      references PARTY_USER.PARTY (PARTY_ID) on delete restrict on update restrict;

alter table USER_ACCT.PAYMENT add constraint FKK_PAYMENT_METHOD_122 foreign key (PAYMENT_METHOD)
      references USER_ACCT.PAYMENT_METHOD (PAYMENT_METHOD) on delete restrict on update restrict;

alter table USER_ACCT.PAYMENT add constraint FKK_PAYMENT_METHOD_207 foreign key (PAYED_METHOD)
      references USER_ACCT.PAYMENT_METHOD (PAYMENT_METHOD) on delete restrict on update restrict;

alter table USER_ACCT.PAYMENT add constraint FKK_STAFF_147 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.STAFF (STAFF_ID) on delete restrict on update restrict;

alter table USER_ACCT.PAYMENT_PLAN add constraint FKK_ACCT_286 foreign key (ACCT_ID)
      references USER_ACCT.ACCT (ACCT_ID) on delete restrict on update restrict;

alter table USER_ACCT.PAYMENT_PLAN add constraint FKK_PAYMENT_METHOD_287 foreign key (PAYMENT_METHOD)
      references USER_ACCT.PAYMENT_METHOD (PAYMENT_METHOD) on delete restrict on update restrict;

alter table USER_ACCT.PAYMENT_RULE add constraint FKK_AGREEMENT_119 foreign key (CUST_AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table PAY_STRATEGY add constraint FK_Reference_426 foreign key (TRADE_TYPE_ID)
      references TRADE_TYPE (TRADE_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.PLUSMINUS add constraint FKK_ACCT_ITEM_TYPE_71 foreign key (ACCT_ITEM_TYPE_ID)
      references USER_ACCT.ACCT_ITEM_TYPE (ACCT_ITEM_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.PLUSMINUS add constraint FKK_BILLING_CYCLE_144 foreign key (FEE_CYCLE_ID)
      references USER_ACCT.BILLING_CYCLE (BILLING_CYCLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.PLUSMINUS add constraint FKK_BILLING_CYCLE_76 foreign key (BILLING_CYCLE_ID)
      references USER_ACCT.BILLING_CYCLE (BILLING_CYCLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.PLUSMINUS add constraint FKK_STAFF_145 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.STAFF (STAFF_ID) on delete restrict on update restrict;

alter table USER_LOCATION.POLITICAL_REGION add constraint FKK_POLITICAL_REGION_333 foreign key (PARENT_REGION_ID)
      references USER_LOCATION.POLITICAL_REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_LOCATION.POLITICAL_REGION add constraint FKK_REGION_334 foreign key (REGION_ID)
      references USER_LOCATION.REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_EVENT.PRERATE_EVENT add constraint FKK_DEST_EVENT_TYPE_307 foreign key (EVENT_TYPE_ID)
      references USER_EVENT.DEST_EVENT_TYPE (EVENT_TYPE_ID) on delete restrict on update restrict;

alter table USER_EVENT.PRERATE_EVENT add constraint FKK_EVENT_CONTENT_INDEX_305 foreign key (EVENT_CONTENT_ID)
      references USER_EVENT.EVENT_CONTENT_INDEX (EVENT_CONTENT_ID) on delete restrict on update restrict;

alter table USER_EVENT.PRERATE_EVENT add constraint FKK_SOURCE_EVENT_309 foreign key (EVENT_ID)
      references USER_EVENT.SOURCE_EVENT (EVENT_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_COMBINE add constraint FKK_EVENT_PRICING_STRATEGY_42 foreign key (EVENT_PRICING_STRATEGY_ID)
      references USER_PRICING.EVENT_PRICING_STRATEGY (EVENT_PRICING_STRATEGY_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_COMBINE add constraint FKK_PRICING_PLAN_43 foreign key (PRICING_PLAN_ID)
      references USER_PRICING.PRICING_PLAN (PRICING_PLAN_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_COMBINE add constraint FK_Reference_361 foreign key (OFFER_OBJECT_ID)
      references USER_PRODUCT.PRODUCT_OFFER_OBJECT (OFFER_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_COMBINE add constraint FK_Reference_374 foreign key (LIF_LIFE_CYCLE_ID)
      references USER_PRICING.LIFE_CYCLE2 (LIFE_CYCLE_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_COMBINE_RELATION add constraint FKK_PRICING_COMBINE_52 foreign key (A_PRICING_COMBINE_ID)
      references USER_PRICING.PRICING_COMBINE (PRICING_COMBINE_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_COMBINE_RELATION add constraint FKK_PRICING_COMBINE_53 foreign key (Z_PRICING_COMBINE_ID)
      references USER_PRICING.PRICING_COMBINE (PRICING_COMBINE_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_ENUM_PARAM add constraint FKK_PRICING_PARAM_DEFINE_38 foreign key (PRICING_PARAM_ID)
      references USER_PRICING.PRICING_PARAM_DEFINE (PRICING_PARAM_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_REF_OBJECT add constraint FKK_MEASURE_METHOD_232 foreign key (MEASURE_METHOD_ID)
      references USER_PRICING.MEASURE_METHOD (MEASURE_METHOD_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_REF_OBJECT add constraint FKK_OWNER_20 foreign key (OWNER_ID)
      references USER_PRICING.OWNER (OWNER_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_RULE add constraint FKK_OPERATOR_23 foreign key (OPERATOR_ID)
      references USER_PRICING.OPERATOR (OPERATOR_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_RULE add constraint FKK_PRICING_REF_OBJECT_24 foreign key (PRICING_REF_OBJECT_ID)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_RULE add constraint FKK_PRICING_SECTION_22 foreign key (PRICING_SECTION_ID)
      references USER_PRICING.PRICING_SECTION (PRICING_SECTION_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_RULE add constraint FKK_REF_VALUE_234 foreign key (RESULT_REF_VALUE_ID)
      references USER_PRICING.REF_VALUE (REF_VALUE_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_SECTION add constraint FKK_EVENT_PRICING_STRATEGY_196 foreign key (EVENT_PRICING_STRATEGY_ID)
      references USER_PRICING.EVENT_PRICING_STRATEGY (EVENT_PRICING_STRATEGY_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_SECTION add constraint FKK_PRICING_REF_OBJECT_19 foreign key (PRICING_REF_OBJECT_ID)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_SECTION add constraint FKK_PRICING_SECTION_21 foreign key (PARENT_SECTION_ID)
      references USER_PRICING.PRICING_SECTION (PRICING_SECTION_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_SECTION add constraint FKK_PRICING_SECTION_TYPE_200 foreign key (SECTION_TYPE_ID)
      references USER_PRICING.PRICING_SECTION_TYPE (SECTION_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_SECTION add constraint FKK_REF_VALUE_228 foreign key (END_REF_VALUE_ID)
      references USER_PRICING.REF_VALUE (REF_VALUE_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_SECTION add constraint FKK_REF_VALUE_229 foreign key (START_REF_VALUE_ID)
      references USER_PRICING.REF_VALUE (REF_VALUE_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_SECTION add constraint FKK_ZONE_ITEM_35 foreign key (ZONE_ITEM_ID)
      references USER_PRICING.ZONE_ITEM (ZONE_ITEM_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_SECTION_RELATION add constraint FKK_PRICING_SECTION_44 foreign key (A_SECTION_ID)
      references USER_PRICING.PRICING_SECTION (PRICING_SECTION_ID) on delete restrict on update restrict;

alter table USER_PRICING.PRICING_SECTION_RELATION add constraint FKK_PRICING_SECTION_45 foreign key (Z_SECTION_ID)
      references USER_PRICING.PRICING_SECTION (PRICING_SECTION_ID) on delete restrict on update restrict;

alter table PARTY_USER.PRIVILEGE add constraint FKK_PRIVILEGE_189 foreign key (PARENT_PRIVILEGEID)
      references PARTY_USER.PRIVILEGE (PRIVILEGE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT add constraint FKK_PARTY_ROLE_205 foreign key (PRODUCT_PROVIDER_ID)
      references PARTY_USER.PARTY_ROLE (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT add constraint FKK_PRICING_PLAN_107 foreign key (PRICING_PLAN_ID)
      references USER_PRICING.PRICING_PLAN (PRICING_PLAN_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT add constraint FKK_PRODUCT_FAMILY_257 foreign key (PRODUCT_FAMILY_ID)
      references USER_PRODUCT.PRODUCT_FAMILY (PRODUCT_FAMILY_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT add constraint FK_Reference_434 foreign key (INTEGRAL_PRICING_PLAN_ID)
      references USER_PRICING.PRICING_PLAN (PRICING_PLAN_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_ATTR add constraint FKK_ATTR_VALUE_TYPE_210 foreign key (ATTR_VALUE_TYPE_ID)
      references USER_PRODUCT.ATTR_VALUE_TYPE (ATTR_VALUE_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_ATTR add constraint FKK_ATTR_VALUE_UNIT_212 foreign key (ATTR_VALUE_UNIT_ID)
      references USER_PRODUCT.ATTR_VALUE_UNIT (ATTR_VALUE_UNIT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_ATTR add constraint FKK_PRODUCT_1 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER add constraint FKK_BAND_254 foreign key (BAND_ID)
      references USER_PRODUCT.BAND (BAND_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER add constraint FKK_PRICING_PLAN_273 foreign key (PRICING_PLAN_ID)
      references USER_PRICING.PRICING_PLAN (PRICING_PLAN_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER add constraint FK_Reference_435 foreign key (INTEGRAL_PRICING_PLAN_ID)
      references USER_PRICING.PRICING_PLAN (PRICING_PLAN_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_ATTR add constraint FKK_ATTR_VALUE_TYPE_211 foreign key (ATTR_VALUE_TYPE_ID)
      references USER_PRODUCT.ATTR_VALUE_TYPE (ATTR_VALUE_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_ATTR add constraint FKK_ATTR_VALUE_UNIT_213 foreign key (ATTR_VALUE_UNIT_ID)
      references USER_PRODUCT.ATTR_VALUE_UNIT (ATTR_VALUE_UNIT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_ATTR add constraint FKK_PRODUCT_OFFER_14 foreign key (OFFER_ID)
      references USER_PRODUCT.PRODUCT_OFFER (OFFER_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_INSTANCE add constraint FKK_AGREEMENT_198 foreign key (CUST_AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_INSTANCE add constraint FKK_CUST_197 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_INSTANCE add constraint FKK_PRODUCT_OFFER_272 foreign key (OFFER_ID)
      references USER_PRODUCT.PRODUCT_OFFER (OFFER_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_INSTANCE_ATTR add constraint FKK_AGREEMENT_215 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_INSTANCE_ATTR add constraint FKK_PRODUCT_OFFER_ATTR_216 foreign key (ATTR_ID)
      references USER_PRODUCT.PRODUCT_OFFER_ATTR (OFFER_ATTR_SEQ) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_INSTANCE_ATTR add constraint FKK_PRODUCT_OFFER_INSTANCE_214 foreign key (SERV_ID)
      references USER_PRODUCT.PRODUCT_OFFER_INSTANCE (PRODUCT_OFFER_INSTANCE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_OBJECT add constraint FKK_PRODUCT_OFFER_252 foreign key (OFFER_ID)
      references USER_PRODUCT.PRODUCT_OFFER (OFFER_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_OBJECT_INSTANCE add constraint FKK_PRODUCT_OFFER_INSTANCE_259 foreign key (PRODUCT_OFFER_INSTANCE_ID)
      references USER_PRODUCT.PRODUCT_OFFER_INSTANCE (PRODUCT_OFFER_INSTANCE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_OBJECT_INSTANCE add constraint FKK_PRODUCT_OFFER_OBJECT_268 foreign key (OFFER_OBJECT_ID)
      references USER_PRODUCT.PRODUCT_OFFER_OBJECT (OFFER_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_PARAM add constraint FKK_PRODUCT_OFFER_253 foreign key (OFFER_ID)
      references USER_PRODUCT.PRODUCT_OFFER (OFFER_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_PARAM_INSTANCE add constraint FKK_LIFE_CYCLE_266 foreign key (LIFE_CYCLE_ID)
      references USER_PRICING.LIFE_CYCLE (LIFE_CYCLE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_PARAM_INSTANCE add constraint FKK_PRODUCT_OFFER_INSTANCE_260 foreign key (PRODUCT_OFFER_INSTANCE_ID)
      references USER_PRODUCT.PRODUCT_OFFER_INSTANCE (PRODUCT_OFFER_INSTANCE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_PARAM_INSTANCE add constraint FKK_PRODUCT_OFFER_PARAM_269 foreign key (OFFER_PARAM_ID)
      references USER_PRODUCT.PRODUCT_OFFER_PARAM (OFFER_PARAM_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_PARAM_INSTANCE add constraint FK_Reference_376 foreign key (OFFER_OBJECT_INSTANCE_ID)
      references USER_PRODUCT.PRODUCT_OFFER_OBJECT_INSTANCE (OFFER_OBJECT_INSTANCE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_RELATION add constraint FKK_PRODUCT_OFFER_10 foreign key (OFFER_Z_ID)
      references USER_PRODUCT.PRODUCT_OFFER (OFFER_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_RELATION add constraint FKK_PRODUCT_OFFER_9 foreign key (OFFER_A_ID)
      references USER_PRODUCT.PRODUCT_OFFER (OFFER_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_RESTRICATION add constraint FKK_MAKET_STRATEGY_13 foreign key (STRATEGY_ID)
      references USER_PRODUCT.MAKET_STRATEGY (STRATEGY_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_OFFER_RESTRICATION add constraint FKK_PRODUCT_OFFER_12 foreign key (OFFER_ID)
      references USER_PRODUCT.PRODUCT_OFFER (OFFER_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_RELATION add constraint FKK_EXTERNAL_PRODUCT_3 foreign key (PROD_Z_ID)
      references USER_PRODUCT.EXTERNAL_PRODUCT (EXTERNAL_PRODUC_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_RELATION add constraint FKK_PARTY_ROLE_202 foreign key (PROD_A_PROVIDER_ID)
      references PARTY_USER.PARTY_ROLE (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_RELATION add constraint FKK_PARTY_ROLE_204 foreign key (PROD_Z_PROVIDER_ID)
      references PARTY_USER.PARTY_ROLE (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_RELATION add constraint FKK_PRODUCT_2 foreign key (PROD_A_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_RELATION add constraint FKK_PRODUCT_RELATION_TYPE_4 foreign key (RELATION_TYPE_ID)
      references USER_PRODUCT.PRODUCT_RELATION_TYPE (RELATION_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_RESOURCE add constraint FKK_PRODUCT_8 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_USAGE_EVENT_TYPE add constraint FKK_DEST_EVENT_TYPE_322 foreign key (EVENT_TYPE_ID)
      references USER_EVENT.DEST_EVENT_TYPE (EVENT_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.PRODUCT_USAGE_EVENT_TYPE add constraint FKK_PRODUCT_5 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;



alter table PROVIDED_CAPABILITY_INFO add constraint FK_Reference_374 foreign key (CAPABILITY_ID)
      references CAPABILITY_INFO (CAPABILITY_ID) on delete restrict on update restrict;

alter table USER_ACCT.RATABLE_CYCLE add constraint FKK_RATABLE_CYCLE_TYPE_299 foreign key (RATABLE_CYCLE_TYPE_ID)
      references USER_ACCT.RATABLE_CYCLE_TYPE (RATABLE_CYCLE_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRICING.RATABLE_RESOURCE add constraint FKK_TARIFF_UNIT_31 foreign key (ORG_TARIFF_UNIT_ID)
      references USER_PRICING.TARIFF_UNIT (TARIFF_UNIT_ID) on delete restrict on update restrict;

alter table USER_PRICING.RATABLE_RESOURCE add constraint FK_Reference_364 foreign key (DEFAULT_RATABLE_CYCLE_TYPE_ID)
      references USER_ACCT.RATABLE_CYCLE_TYPE (RATABLE_CYCLE_TYPE_ID) on delete restrict on update restrict;

alter table USER_ACCT.RATABLE_RESOURCE_ACCUMULATOR add constraint FKK_RATABLE_CYCLE_298 foreign key (RATABLE_CYCLE_ID)
      references USER_ACCT.RATABLE_CYCLE (RATABLE_CYCLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.RATABLE_RESOURCE_ACCUMULATOR add constraint FKK_RATABLE_RESOURCE_236 foreign key (RATABLE_RESOURCE_ID)
      references USER_PRICING.RATABLE_RESOURCE (RATABLE_RESOURCE_ID) on delete restrict on update restrict;

alter table USER_EVENT.RATED_EVENT add constraint FKK_DEST_EVENT_TYPE_308 foreign key (EVENT_TYPE_ID)
      references USER_EVENT.DEST_EVENT_TYPE (EVENT_TYPE_ID) on delete restrict on update restrict;

alter table USER_EVENT.RATED_EVENT add constraint FKK_EVENT_CONTENT_INDEX_304 foreign key (EVENT_CONTENT_ID)
      references USER_EVENT.EVENT_CONTENT_INDEX (EVENT_CONTENT_ID) on delete restrict on update restrict;

alter table USER_EVENT.RATED_EVENT add constraint FKK_SERV_323 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_EVENT.RATED_EVENT add constraint FKK_SOURCE_EVENT_310 foreign key (EVENT_ID)
      references USER_EVENT.SOURCE_EVENT (EVENT_ID) on delete restrict on update restrict;

alter table USER_PRICING.REF_VALUE add constraint FKK_PRICING_PARAM_DEFINE_233 foreign key (PRICING_PRARM_ID)
      references USER_PRICING.PRICING_PARAM_DEFINE (PRICING_PARAM_ID) on delete restrict on update restrict;

alter table USER_PRICING.REF_VALUE add constraint FKK_PRICING_REF_OBJECT_235 foreign key (PRICING_REF_OBJECT_ID)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table PARTY_USER.ROLE_PRIVILEGE add constraint FKK_PRIVILEGE_194 foreign key (PRIVILEGE_ID)
      references PARTY_USER.PRIVILEGE (PRIVILEGE_ID) on delete restrict on update restrict;

alter table PARTY_USER.ROLE_PRIVILEGE add constraint FKK_ROLE_195 foreign key (ROLE_ID)
      references PARTY_USER.ROLE (ROLE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV add constraint FKK_AGREEMENT_153 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV add constraint FKK_BILLING_CYCLE_TYPE_249 foreign key (BILLING_CYCLE_TYPE_ID)
      references USER_ACCT.BILLING_CYCLE_TYPE (BILLING_CYCLE_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV add constraint FKK_CUST_157 foreign key (CUST_ID)
      references PARTY_USER.CUST (CUST_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV add constraint FKK_PRODUCT_156 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV add constraint FKK_PRODUCT_FAMILY_261 foreign key (PRODUCT_FAMILY_ID)
      references USER_PRODUCT.PRODUCT_FAMILY (PRODUCT_FAMILY_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERVICE_OFFER add constraint FKK_ACTION_11 foreign key (ACTION_ID)
      references USER_PRODUCT.ACTION (ACTION_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERVICE_OFFER add constraint FKK_PRODUCT_7 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table USER_ACCT.SERV_ACCT add constraint FKK_ACCT_77 foreign key (ACCT_ID)
      references USER_ACCT.ACCT (ACCT_ID) on delete restrict on update restrict;

alter table USER_ACCT.SERV_ACCT add constraint FKK_ACCT_ITEM_GROUP_56 foreign key (ACCT_ITEM_GROUP_ID)
      references USER_ACCT.ACCT_ITEM_GROUP (ACCT_ITEM_GROUP_ID) on delete restrict on update restrict;

alter table USER_ACCT.SERV_ACCT add constraint FKK_PAYMENT_RULE_78 foreign key (PAYMENT_RULE_ID)
      references USER_ACCT.PAYMENT_RULE (PAYMENT_RULE_ID) on delete restrict on update restrict;

alter table USER_ACCT.SERV_ACCT add constraint FKK_SERV_118 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;



alter table USER_PRODUCT.SERV_ATTR add constraint FKK_AGREEMENT_159 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_ATTR add constraint FKK_PRODUCT_ATTR_165 foreign key (ATTR_ID)
      references USER_PRODUCT.PRODUCT_ATTR (ATTR_SEQ) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_ATTR add constraint FKK_SERV_94 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table SERV_AUTH add constraint FK_Reference_383 foreign key (EVENT_TYPE_ID)
      references USER_EVENT.DEST_EVENT_TYPE (EVENT_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_BILLING_MODE add constraint FKK_SERV_251 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_IDENTIFICATION add constraint FKK_AGREEMENT_160 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_IDENTIFICATION add constraint FKK_SERV_92 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_LOCATION add constraint FKK_ADDRESS_112 foreign key (ADDRESS_ID)
      references USER_LOCATION.ADDRESS (ADDRESS_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_LOCATION add constraint FKK_AGREEMENT_162 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_LOCATION add constraint FKK_BILLING_REGION_113 foreign key (EXCHANGE_ID)
      references USER_LOCATION.BILLING_REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_LOCATION add constraint FKK_ORGANIZATION_341 foreign key (BUREAU_ID)
      references PARTY_USER.ORGANIZATION (ORG_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_LOCATION add constraint FKK_SERV_91 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_LOCATION add constraint FKK_STAT_REGION_340 foreign key (STAT_REGION_ID)
      references USER_LOCATION.STAT_REGION (REGION_ID) on delete restrict on update restrict;

alter table PARTY_USER.SERV_POINTS_REWARD_RECORD add constraint FKK_INTEGRAL_RESULT_279 foreign key (INTEGRAL_REAULT_ID)
      references PARTY_USER.INTEGRAL_RESULT (INTEGRAL_REAULT_ID) on delete restrict on update restrict;

alter table PARTY_USER.SERV_POINTS_REWARD_RECORD add constraint FKK_PRESENT_281 foreign key (PRESENT_ID)
      references PARTY_USER.PRESENT (PRESENT_ID) on delete restrict on update restrict;

alter table PARTY_USER.SERV_POINTS_REWARD_RULE add constraint FKK_PRESENT_282 foreign key (PRESENT_ID)
      references PARTY_USER.PRESENT (PRESENT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_PRODUCT add constraint FKK_AGREEMENT_158 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_PRODUCT add constraint FKK_PRODUCT_163 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_PRODUCT add constraint FKK_SERV_90 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_PRODUCT_ATTR add constraint FKK_PRODUCT_ATTR_164 foreign key (ATTR_ID)
      references USER_PRODUCT.PRODUCT_ATTR (ATTR_SEQ) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_PRODUCT_ATTR add constraint FKK_SERV_PRODUCT_89 foreign key (SERV_PRODUCT_ID)
      references USER_PRODUCT.SERV_PRODUCT (SERV_PRODUCT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_RELATION add constraint FK_Reference_362 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_RELATION add constraint FK_Reference_363 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;


alter table USER_PRODUCT.SERV_STATE_ATTR add constraint FKK_OWE_BUSINESS_TYPE_238 foreign key (OWE_BUSINESS_TYPE_ID)
      references USER_ACCT.OWE_BUSINESS_TYPE (OWE_BUSINESS_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_STATE_ATTR add constraint FKK_SERV_225 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_SUBSRIBER add constraint FKK_AGREEMENT_161 foreign key (AGREEMENT_ID)
      references PARTY_USER.AGREEMENT (AGREEMENT_ID) on delete restrict on update restrict;

alter table USER_PRODUCT.SERV_SUBSRIBER add constraint FKK_SERV_93 foreign key (SERV_ID)
      references USER_PRODUCT.SERV (SERV_ID) on delete restrict on update restrict;

alter table USER_ACCT.SETTLE_CATALOG add constraint FKK_PARTNER_342 foreign key (CATALOG_ID)
      references PARTY_USER.PARTNER (PARTY_ID) on delete restrict on update restrict;

alter table USER_ACCT.SETTLE_CATALOG_ITEM add constraint FKK_SETTLE_CATALOG_343 foreign key (CATALOG_ID)
      references USER_ACCT.SETTLE_CATALOG (CATALOG_ID) on delete restrict on update restrict;

alter table USER_ACCT.SETTLE_CATALOG_ITEM_ELEMENT add constraint FKK_SETTLE_CATALOG_ITEM_344 foreign key (CATALOG_ITEM_ID)
      references USER_ACCT.SETTLE_CATALOG_ITEM (CATALOG_ITEM_ID) on delete restrict on update restrict;

alter table USER_ACCT.SETTLE_CATALOG_ITEM_ELEMENT add constraint FKK_SETTLE_RULE_345 foreign key (ELEMENT_ID)
      references USER_ACCT.SETTLE_RULE (SETTLE_RULE_ID) on delete restrict on update restrict;

alter table USER_ACCT.SETTLE_RULE add constraint FKK_EVENT_PRICING_STRATEGY_346 foreign key (EVENT_PRICING_STRATEGY_ID)
      references USER_PRICING.EVENT_PRICING_STRATEGY (EVENT_PRICING_STRATEGY_ID) on delete restrict on update restrict;

alter table USER_EVENT.SOURCE_EVENT add constraint FKK_EVENT_CONTENT_INDEX_306 foreign key (EVENT_CONTENT_ID)
      references USER_EVENT.EVENT_CONTENT_INDEX (EVENT_CONTENT_ID) on delete restrict on update restrict;

alter table USER_EVENT.SOURCE_EVENT add constraint FKK_SOURCE_EVENT_TYPE_316 foreign key (SOURCE_EVENT_TYPE)
      references USER_EVENT.SOURCE_EVENT_TYPE (SOURCE_EVENT_TYPE) on delete restrict on update restrict;

alter table USER_EVENT.SOURCE_EVENT_FORMAT add constraint FKK_SOURCE_EVENT_TYPE_320 foreign key (SOURCE_EVENT_TYPE)
      references USER_EVENT.SOURCE_EVENT_TYPE (SOURCE_EVENT_TYPE) on delete restrict on update restrict;

alter table USER_EVENT.SOURCE_EVENT_FORMAT_ITEM add constraint FKK_DATA_FORMAT_301 foreign key (DATA_FORMAT_ID)
      references USER_EVENT.DATA_FORMAT (DATA_FORMAT_ID) on delete restrict on update restrict;

alter table USER_EVENT.SOURCE_EVENT_FORMAT_ITEM add constraint FKK_EVENT_ATTR_315 foreign key (EVENT_ATTR_ID)
      references USER_EVENT.EVENT_ATTR (EVENT_ATTR_ID) on delete restrict on update restrict;

alter table USER_EVENT.SOURCE_EVENT_FORMAT_ITEM add constraint FKK_SOURCE_EVENT_FORMAT_S_314 foreign key (EVENT_FORMAT_SEGMENT_ID)
      references USER_EVENT.SOURCE_EVENT_FORMAT_SEGMENT (EVENT_FORMAT_SEGMENT_ID) on delete restrict on update restrict;

alter table USER_EVENT.SOURCE_EVENT_FORMAT_NORMAL add constraint FKK_SOURCE_EVENT_FORMAT_317 foreign key (EVENT_FORMAT_ID)
      references USER_EVENT.SOURCE_EVENT_FORMAT (EVENT_FORMAT_ID) on delete restrict on update restrict;

alter table USER_EVENT.SOURCE_EVENT_FORMAT_OTHER add constraint FKK_SOURCE_EVENT_FORMAT_318 foreign key (EVENT_FORMAT_ID)
      references USER_EVENT.SOURCE_EVENT_FORMAT (EVENT_FORMAT_ID) on delete restrict on update restrict;

alter table USER_EVENT.SOURCE_EVENT_FORMAT_SEGMENT add constraint FKK_SOURCE_EVENT_FORMAT_N_319 foreign key (EVENT_FORMAT_ID)
      references USER_EVENT.SOURCE_EVENT_FORMAT_NORMAL (EVENT_FORMAT_ID) on delete restrict on update restrict;

alter table USER_LOCATION.SPECIAL_HEAD add constraint FKK_BILLING_REGION_324 foreign key (LATN_ID)
      references USER_LOCATION.BILLING_REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_LOCATION.SPECIAL_HEAD add constraint FKK_EMULATORY_PARTNER_331 foreign key (EMULATORY_PARTNER_ID)
      references PARTY_USER.EMULATORY_PARTNER (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table USER_ACCT.SPECIAL_PAYMENT add constraint FKK_ACCT_ITEM_GROUP_297 foreign key (ACCT_ITEM_GROUP_ID)
      references USER_ACCT.ACCT_ITEM_GROUP (ACCT_ITEM_GROUP_ID) on delete restrict on update restrict;

alter table USER_ACCT.SPECIAL_PAYMENT add constraint FKK_PARTNER_138 foreign key (PARTNER_ID)
      references PARTY_USER.PARTNER (PARTY_ID) on delete restrict on update restrict;

alter table USER_ACCT.SPECIAL_PAYMENT add constraint FKK_PRODUCT_139 foreign key (PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table USER_ACCT.SPECIAL_PAYMENT add constraint FKK_SPECIAL_PAYMENT_DESC_80 foreign key (SPE_PAYMENT_ID)
      references USER_ACCT.SPECIAL_PAYMENT_DESC (SPE_PAYMENT_ID) on delete restrict on update restrict;

alter table PARTY_USER.STAFF add constraint FKK_ORGANIZATION_250 foreign key (OPERATE_ORG_ID)
      references PARTY_USER.ORGANIZATION (ORG_ID) on delete restrict on update restrict;

alter table PARTY_USER.STAFF add constraint FKK_PARTY_ROLE_184 foreign key (STAFF_ID)
      references PARTY_USER.PARTY_ROLE (PARTY_ROLE_ID) on delete restrict on update restrict;

alter table PARTY_USER.STAFF add constraint FKK_STAFF_103 foreign key (PARENT_PARTYROLEID)
      references PARTY_USER.STAFF (STAFF_ID) on delete restrict on update restrict;

alter table PARTY_USER.STAFF_PRIVILEGE add constraint FKK_PRIVILEGE_193 foreign key (PRIVILEGE_ID)
      references PARTY_USER.PRIVILEGE (PRIVILEGE_ID) on delete restrict on update restrict;

alter table PARTY_USER.STAFF_PRIVILEGE add constraint FKK_STAFF_192 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.STAFF (STAFF_ID) on delete restrict on update restrict;

alter table PARTY_USER.STAFF_ROLE add constraint FKK_ROLE_191 foreign key (ROLE_ID)
      references PARTY_USER.ROLE (ROLE_ID) on delete restrict on update restrict;

alter table PARTY_USER.STAFF_ROLE add constraint FKK_STAFF_190 foreign key (PARTY_ROLE_ID)
      references PARTY_USER.STAFF (STAFF_ID) on delete restrict on update restrict;

alter table USER_STAT.STATS_CHECK2 add constraint FKK_EXTERNAL_TREE_STRUCT_357 foreign key (TREE_NODE_ID)
      references USER_STAT.EXTERNAL_TREE_STRUCT2 (EXTERNAL_TREE_NODE_ID) on delete restrict on update restrict;

alter table USER_STAT.STATS_CHECK2 add constraint FKK_INTERNAL_TREE_STRUCT_356 foreign key (TREE_NODE_ID)
      references USER_STAT.INTERNAL_TREE_STRUCT2 (INTERNAL_TREE_NODE_ID) on delete restrict on update restrict;

alter table USER_LOCATION.STAT_REGION add constraint FKK_REGION_336 foreign key (REGION_ID)
      references USER_LOCATION.REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_LOCATION.STAT_REGION add constraint FKK_STAT_REGION_327 foreign key (PARENT_REGION_ID)
      references USER_LOCATION.STAT_REGION (REGION_ID) on delete restrict on update restrict;

alter table USER_STAT.STA_TARGET_SYNTAX2 add constraint FKK_EXTERNAL_TREE_STRUCT_354 foreign key (EXTERNAL_TREE_NODE_ID)
      references USER_STAT.EXTERNAL_TREE_STRUCT2 (EXTERNAL_TREE_NODE_ID) on delete restrict on update restrict;

alter table USER_ACCT.SUB_BILLING_CYCLE add constraint FKK_BILLING_CYCLE_114 foreign key (BILLING_CYCLE_ID)
      references USER_ACCT.BILLING_CYCLE (BILLING_CYCLE_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FKK_ACCT_ITEM_TYPE_117 foreign key (ACCT_ITEM_TYPE_ID)
      references USER_ACCT.ACCT_ITEM_TYPE (ACCT_ITEM_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FKK_ACTION_175 foreign key (ACTION_ID)
      references USER_PRODUCT.ACTION (ACTION_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FKK_PRICING_SECTION_18 foreign key (PRICING_SECTION_ID)
      references USER_PRICING.PRICING_SECTION (PRICING_SECTION_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FKK_PRODUCT_116 foreign key (SUB_PRODUCT_ID)
      references USER_PRODUCT.PRODUCT (PRODUCT_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FKK_RATABLE_RESOURCE_17 foreign key (RESOURCE_ID)
      references USER_PRICING.RATABLE_RESOURCE (RATABLE_RESOURCE_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FKK_REF_VALUE_39 foreign key (FIXED_RATE_VALUE_ID)
      references USER_PRICING.REF_VALUE (REF_VALUE_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FKK_REF_VALUE_40 foreign key (SCALED_RATE_VALUE_ID)
      references USER_PRICING.REF_VALUE (REF_VALUE_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FKK_TARIFF_CALC_DESC_15 foreign key (CALC_METHOD_ID)
      references USER_PRICING.TARIFF_CALC_DESC (TARIFF_CALC_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FKK_TARIFF_UNIT_16 foreign key (TARIFF_UNIT_ID)
      references USER_PRICING.TARIFF_UNIT (TARIFF_UNIT_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF add constraint FK_Reference_432 foreign key (INTEGRAL_TYPE_ID)
      references USER_PRICING.INTEGRAL_TYPE (INTEGRAL_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRICING.TARIFF_UNIT add constraint FKK_MEASURE_METHOD_41 foreign key (MEASURE_METHOD_ID)
      references USER_PRICING.MEASURE_METHOD (MEASURE_METHOD_ID) on delete restrict on update restrict;

alter table TIME_PERIOD_DEFINE add constraint FK_Reference_423 foreign key (TIME_PERIOD_ID)
      references TIME_PERIOD (TIME_PERIOD_ID) on delete restrict on update restrict;

alter table TRADE_RECORD add constraint FK_Reference_427 foreign key (TRADE_TYPE_ID)
      references TRADE_TYPE (TRADE_TYPE_ID) on delete restrict on update restrict;

alter table USER_PRICING.ZONE add constraint FKK_PRICING_REF_OBJECT_54 foreign key (PRICING_REF_OBJECT_ID)
      references USER_PRICING.PRICING_REF_OBJECT (PRICING_REF_OBJECT_ID) on delete restrict on update restrict;

alter table USER_PRICING.ZONE_ITEM add constraint FKK_ZONE_33 foreign key (ZONE_ID)
      references USER_PRICING.ZONE (ZONE_ID) on delete restrict on update restrict;

alter table USER_PRICING.ZONE_ITEM add constraint FKK_ZONE_ITEM_32 foreign key (PARENT_ZONE_ITEM_ID)
      references USER_PRICING.ZONE_ITEM (ZONE_ITEM_ID) on delete restrict on update restrict;

alter table USER_PRICING.ZONE_ITEM_VALUE add constraint FK_Reference_375 foreign key (ZONE_ITEM_ID)
      references USER_PRICING.ZONE_ITEM (ZONE_ITEM_ID) on delete restrict on update restrict;


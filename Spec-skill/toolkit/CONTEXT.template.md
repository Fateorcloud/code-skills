# {上下文名称}

{一两句话说明这个上下文是什么、为何存在。}

## Language（领域术语）

**Order（订单）**:
一两句定义"它**是什么**"（不是它做什么）。
_Avoid_: Purchase, Transaction

**Invoice（发票）**:
交付后向客户发出的付款请求。
_Avoid_: Bill, 付款请求

**Customer（客户）**:
下单的个人或组织。
_Avoid_: Client, Buyer, Account

## Relationships（关系）

- 一个 **Customer** 可有多个 **Order**
- **Ordering → Fulfillment**：Ordering 发出 `OrderPlaced` 事件，Fulfillment 消费它开始拣货

## Flagged ambiguities（已澄清的歧义，可选）

- "backlog" 曾同时指*工具*和*工作内容*——已澄清：工具叫 **Issue tracker**，"backlog" 不再作为术语使用。

---
<!--
规则（吸收自 mattpocock/skills 的 CONTEXT-FORMAT.md）：
- 要有主见：一个概念多个词时，选最佳的，其余列进 _Avoid_。
- 定义要紧凑：最多一两句，定义"是什么"不是"做什么"。
- 只收项目特有术语：通用编程概念（超时、错误类型、工具模式）不收，哪怕项目大量用到。
  加之前先问：这是本上下文独有的概念，还是通用编程概念？只有前者才收。
- 术语多时按子标题分组；若都属一个内聚领域，平铺即可。
- 多上下文项目：根目录放 CONTEXT-MAP.md，列出各上下文位置与彼此关系，指向各自的 CONTEXT.md。
-->

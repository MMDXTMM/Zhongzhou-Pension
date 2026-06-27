<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="老人姓名" prop="elderName">
        <el-input
          v-model="queryParams.elderName"
          placeholder="请输入老人姓名"
          clearable
          style="width: 240px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="退住状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="退住状态" clearable>
          <el-option label="待审核" value="0" />
          <el-option label="审核通过" value="1" />
          <el-option label="审核驳回" value="2" />
          <el-option label="已退住" value="3" />
        </el-select>
      </el-form-item>
      <el-form-item label="申请日期">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['admission:checkout:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['admission:checkout:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['admission:checkout:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['admission:checkout:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="checkoutList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="退住编号" align="center" prop="checkOutNo" width="120" />
      <el-table-column label="老人姓名" align="center" prop="elderName" :show-overflow-tooltip="true" />
      <el-table-column label="身份证号" align="center" prop="idCard" width="180" />
      <el-table-column label="床位号" align="center" prop="bedNo" width="100" />
      <el-table-column label="退住原因" align="center" prop="reason" />
      <el-table-column label="退住状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === '0'" type="warning">待审核</el-tag>
          <el-tag v-else-if="scope.row.status === '1'" type="primary">审核通过</el-tag>
          <el-tag v-else-if="scope.row.status === '2'" type="danger">审核驳回</el-tag>
          <el-tag v-else-if="scope.row.status === '3'" type="success">已退住</el-tag>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="申请日期" align="center" prop="applyDate" width="120">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.applyDate) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="260">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['admission:checkout:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-s-check"
            @click="handleApprove(scope.row)"
            v-hasPermi="['admission:checkout:approve']"
            v-if="scope.row.status === '0'"
          >审核</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-finished"
            @click="handleComplete(scope.row)"
            v-hasPermi="['admission:checkout:complete']"
            v-if="scope.row.status === '1'"
          >完成退住</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['admission:checkout:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="老人姓名" prop="elderName">
              <el-input v-model="form.elderName" placeholder="请输入老人姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="身份证号" prop="idCard">
              <el-input v-model="form.idCard" placeholder="请输入身份证号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="床位号" prop="bedNo">
              <el-input v-model="form.bedNo" placeholder="请输入床位号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="退住状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio label="0">待审核</el-radio>
                <el-radio label="1">审核通过</el-radio>
                <el-radio label="2">审核驳回</el-radio>
                <el-radio label="3">已退住</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="申请日期" prop="applyDate">
              <el-date-picker
                v-model="form.applyDate"
                type="date"
                placeholder="选择申请日期"
                value-format="yyyy-MM-dd"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="预计退住日期" prop="expectedCheckOutDate">
              <el-date-picker
                v-model="form.expectedCheckOutDate"
                type="date"
                placeholder="选择预计日期"
                value-format="yyyy-MM-dd"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="退住原因" prop="reason">
          <el-select v-model="form.reason" placeholder="请选择退住原因" clearable style="width: 30%">
            <el-option label="回家养老" value="1" />
            <el-option label="转院治疗" value="2" />
            <el-option label="家属接回" value="3" />
            <el-option label="其他" value="4" />
          </el-select>
        </el-form-item>
        <el-form-item label="退住说明" prop="reasonDetail">
          <el-input v-model="form.reasonDetail" type="textarea" placeholder="请输入退住说明" />
        </el-form-item>
        <el-form-item label="审批人" prop="approver">
          <el-input v-model="form.approver" placeholder="请输入审批人" style="width: 30%" />
        </el-form-item>
        <el-form-item label="审批意见" prop="approveRemark">
          <el-input v-model="form.approveRemark" type="textarea" placeholder="请输入审批意见" />
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="结算金额(元)" prop="settlementAmount">
              <el-input v-model.number="form.settlementAmount" placeholder="请输入结算金额" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="退款金额(元)" prop="refundAmount">
              <el-input v-model.number="form.refundAmount" placeholder="请输入退款金额" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="退住审核" :visible.sync="approveOpen" width="500px" append-to-body>
      <el-form ref="approveForm" :model="approveForm" :rules="approveRules" label-width="80px">
        <el-form-item label="审核结果" prop="approved">
          <el-radio-group v-model="approveForm.approved">
            <el-radio :label="true">通过</el-radio>
            <el-radio :label="false">驳回</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审核意见" prop="approveRemark">
          <el-input v-model="approveForm.approveRemark" type="textarea" placeholder="请输入审核意见" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitApprove">确 定</el-button>
        <el-button @click="approveOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="完成退住" :visible.sync="completeOpen" width="500px" append-to-body>
      <el-form ref="completeForm" :model="completeForm" :rules="completeRules" label-width="100px">
        <el-form-item label="实际退住日期" prop="actualCheckOutDate">
          <el-date-picker
            v-model="completeForm.actualCheckOutDate"
            type="date"
            placeholder="选择实际退住日期"
            value-format="yyyy-MM-dd"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="结算金额(元)" prop="settlementAmount">
          <el-input v-model.number="completeForm.settlementAmount" placeholder="请输入结算金额" />
        </el-form-item>
        <el-form-item label="退款金额(元)" prop="refundAmount">
          <el-input v-model.number="completeForm.refundAmount" placeholder="请输入退款金额" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="completeForm.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitComplete">确 定</el-button>
        <el-button @click="completeOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listCheckout, getCheckout, delCheckout, addCheckout, updateCheckout, approveCheckout, completeCheckout } from "@/api/admission/checkout"

export default {
  name: "Checkout",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      checkoutList: [],
      title: "",
      open: false,
      approveOpen: false,
      completeOpen: false,
      dateRange: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        elderName: undefined,
        status: undefined
      },
      form: {},
      approveForm: {
        id: undefined,
        approved: true,
        approveRemark: undefined
      },
      completeForm: {
        id: undefined,
        actualCheckOutDate: undefined,
        settlementAmount: undefined,
        refundAmount: undefined,
        remark: undefined
      },
      rules: {
        elderName: [
          { required: true, message: "老人姓名不能为空", trigger: "blur" }
        ],
        idCard: [
          { required: true, message: "身份证号不能为空", trigger: "blur" }
        ]
      },
      approveRules: {
        approved: [
          { required: true, message: "请选择审核结果", trigger: "change" }
        ]
      },
      completeRules: {
        actualCheckOutDate: [
          { required: true, message: "请选择实际退住日期", trigger: "change" }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listCheckout(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.checkoutList = response.rows
          this.total = response.total
          this.loading = false
        }
      )
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        id: undefined,
        checkOutNo: undefined,
        elderName: undefined,
        idCard: undefined,
        bedNo: undefined,
        applyDate: undefined,
        expectedCheckOutDate: undefined,
        actualCheckOutDate: undefined,
        reason: undefined,
        reasonDetail: undefined,
        status: "0",
        approver: undefined,
        approveRemark: undefined,
        settlementAmount: undefined,
        refundAmount: undefined,
        remark: undefined
      }
      this.resetForm("form")
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.dateRange = []
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "新增退住申请"
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    handleUpdate(row) {
      this.reset()
      const id = row.id || this.ids
      getCheckout(id).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改退住申请"
      })
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != undefined) {
            updateCheckout(this.form).then(() => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addCheckout(this.form).then(() => {
              this.$modal.msgSuccess("新增成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    handleDelete(row) {
      const ids = row.id || this.ids
      this.$modal.confirm('是否确认删除退住编号为"' + (row.checkOutNo || ids) + '"的数据项？').then(() => {
        return delCheckout(ids)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleApprove(row) {
      this.approveForm.id = row.id
      this.approveForm.approved = true
      this.approveForm.approveRemark = undefined
      this.approveOpen = true
    },
    submitApprove() {
      this.$refs["approveForm"].validate(valid => {
        if (valid) {
          approveCheckout(this.approveForm).then(() => {
            this.$modal.msgSuccess("审核成功")
            this.approveOpen = false
            this.getList()
          })
        }
      })
    },
    handleComplete(row) {
      this.completeForm.id = row.id
      this.completeForm.actualCheckOutDate = undefined
      this.completeForm.settlementAmount = undefined
      this.completeForm.refundAmount = undefined
      this.completeForm.remark = undefined
      this.completeOpen = true
    },
    submitComplete() {
      this.$refs["completeForm"].validate(valid => {
        if (valid) {
          completeCheckout(this.completeForm).then(() => {
            this.$modal.msgSuccess("退住完成")
            this.completeOpen = false
            this.getList()
          })
        }
      })
    },
    handleExport() {
      this.download('admission/checkout/export', {
        ...this.queryParams
      }, `checkout_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>

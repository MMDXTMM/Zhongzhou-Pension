<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="访客姓名" prop="visitorName">
        <el-input
          v-model="queryParams.visitorName"
          placeholder="请输入访客姓名"
          clearable
          style="width: 240px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="被访人姓名" prop="visitedName">
        <el-input
          v-model="queryParams.visitedName"
          placeholder="请输入被访人姓名"
          clearable
          style="width: 240px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="来访状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="来访状态" clearable>
          <el-option label="待审核" :value="0" />
          <el-option label="已预约" :value="1" />
          <el-option label="已签到" :value="2" />
          <el-option label="已离开" :value="3" />
          <el-option label="已取消" :value="4" />
        </el-select>
      </el-form-item>
      <el-form-item label="来访日期">
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
          v-hasPermi="['nursing:visit:add']"
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
          v-hasPermi="['nursing:visit:edit']"
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
          v-hasPermi="['nursing:visit:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['nursing:visit:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="visitList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="id" width="80" />
      <el-table-column label="访客姓名" align="center" prop="visitorName" :show-overflow-tooltip="true" />
      <el-table-column label="访客电话" align="center" prop="visitorPhone" width="120" />
      <el-table-column label="被访人姓名" align="center" prop="visitedName" :show-overflow-tooltip="true" />
      <el-table-column label="被访人部门" align="center" prop="visitedDept" :show-overflow-tooltip="true" />
      <el-table-column label="来访事由" align="center" prop="visitReason" :show-overflow-tooltip="true" />
      <el-table-column label="预约日期" align="center" prop="visitDate" width="120" />
      <el-table-column label="预约时间" align="center" prop="visitTime" width="120" />
      <el-table-column label="来访状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 0" type="danger">待审核</el-tag>
          <el-tag v-else-if="scope.row.status === 1" type="warning">已预约</el-tag>
          <el-tag v-else-if="scope.row.status === 2" type="success">已签到</el-tag>
          <el-tag v-else-if="scope.row.status === 3" type="info">已离开</el-tag>
          <el-tag v-else-if="scope.row.status === 4" type="info">已取消</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="280">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['nursing:visit:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-check"
            @click="handleApprove(scope.row)"
            v-hasPermi="['nursing:visit:approve']"
            v-if="scope.row.status === 0"
          >审核</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-close"
            @click="handleCancel(scope.row)"
            v-hasPermi="['nursing:visit:cancel']"
            v-if="scope.row.status === 0 || scope.row.status === 1"
          >取消</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-s-promotion"
            @click="handleSignIn(scope.row)"
            v-hasPermi="['nursing:visit:signIn']"
            v-if="scope.row.status === 1"
          >签到</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-location-outline"
            @click="handleLeave(scope.row)"
            v-hasPermi="['nursing:visit:leave']"
            v-if="scope.row.status === 2"
          >离开</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['nursing:visit:remove']"
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

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="访客姓名" prop="visitorName">
          <el-input v-model="form.visitorName" placeholder="请输入访客姓名" />
        </el-form-item>
        <el-form-item label="访客电话" prop="visitorPhone">
          <el-input v-model="form.visitorPhone" placeholder="请输入访客电话" />
        </el-form-item>
        <el-form-item label="访客身份证" prop="visitorIdCard">
          <el-input v-model="form.visitorIdCard" placeholder="请输入访客身份证" />
        </el-form-item>
        <el-form-item label="被访人姓名" prop="visitedName">
          <el-input v-model="form.visitedName" placeholder="请输入被访人姓名" />
        </el-form-item>
        <el-form-item label="被访人部门" prop="visitedDept">
          <el-input v-model="form.visitedDept" placeholder="请输入被访人部门" />
        </el-form-item>
        <el-form-item label="来访事由" prop="visitReason">
          <el-input v-model="form.visitReason" type="textarea" placeholder="请输入来访事由" />
        </el-form-item>
        <el-form-item label="预约来访日期" prop="visitDate">
          <el-date-picker
            v-model="form.visitDate"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="预约来访时间" prop="visitTime">
          <el-time-picker
            v-model="form.visitTime"
            type="time"
            placeholder="选择时间"
            value-format="HH:mm"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="来访状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :value="0">待审核</el-radio>
            <el-radio :value="1">已预约</el-radio>
            <el-radio :value="2">已签到</el-radio>
            <el-radio :value="3">已离开</el-radio>
            <el-radio :value="4">已取消</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listVisit, getVisit, delVisit, addVisit, updateVisit, approveVisit, cancelVisit, signInVisit, leaveVisit } from "@/api/nursing/visit"

export default {
  name: "NursingVisit",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      visitList: [],
      title: "",
      open: false,
      dateRange: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        visitorName: undefined,
        visitedName: undefined,
        status: undefined
      },
      form: {},
      rules: {
        visitorName: [
          { required: true, message: "访客姓名不能为空", trigger: "blur" }
        ],
        visitedName: [
          { required: true, message: "被访人姓名不能为空", trigger: "blur" }
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
      listVisit(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.visitList = response.rows
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
        visitorName: undefined,
        visitorPhone: undefined,
        visitorIdCard: undefined,
        visitedName: undefined,
        visitedDept: undefined,
        visitReason: undefined,
        visitDate: undefined,
        visitTime: undefined,
        actualVisitTime: undefined,
        leaveTime: undefined,
        status: 0,
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
      this.title = "新增来访记录"
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    handleUpdate(row) {
      this.reset()
      const id = row.id || this.ids
      getVisit(id).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改来访记录"
      })
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != undefined) {
            updateVisit(this.form).then(() => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addVisit(this.form).then(() => {
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
      this.$modal.confirm('是否确认删除来访编号为"' + ids + '"的数据项？').then(function() {
        return delVisit(ids)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleApprove(row) {
      this.$modal.confirm('是否审核通过编号为"' + row.id + '"的来访申请？').then(function() {
        return approveVisit(row.id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("审核成功")
      }).catch(() => {})
    },
    handleCancel(row) {
      this.$modal.confirm('是否取消编号为"' + row.id + '"的来访申请？').then(function() {
        return cancelVisit(row.id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("取消成功")
      }).catch(() => {})
    },
    handleSignIn(row) {
      this.$modal.confirm('是否确认编号为"' + row.id + '"的访客签到？').then(function() {
        return signInVisit(row.id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("签到成功")
      }).catch(() => {})
    },
    handleLeave(row) {
      this.$modal.confirm('是否确认编号为"' + row.id + '"的访客离开？').then(function() {
        return leaveVisit(row.id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("登记成功")
      }).catch(() => {})
    },
    handleExport() {
      this.download('nursing/visit/export', {
        ...this.queryParams
      }, `visit_record_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>

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
      <el-form-item label="入住状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="入住状态" clearable>
          <el-option label="待办理" value="0" />
          <el-option label="办理中" value="1" />
          <el-option label="已入住" value="2" />
          <el-option label="已取消" value="3" />
          <el-option label="已退住" value="4" />
        </el-select>
      </el-form-item>
      <el-form-item label="入住日期">
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
          v-hasPermi="['admission:checkin:add']"
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
          v-hasPermi="['admission:checkin:edit']"
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
          v-hasPermi="['admission:checkin:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['admission:checkin:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="checkinList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="入住编号" align="center" prop="checkInNo" width="120" />
      <el-table-column label="老人姓名" align="center" prop="elderName" :show-overflow-tooltip="true" />
      <el-table-column label="身份证号" align="center" prop="idCard" width="180" />
      <el-table-column label="联系电话" align="center" prop="phone" width="120" />
      <el-table-column label="护理等级" align="center" prop="nursingLevelName" />
      <el-table-column label="床位号" align="center" prop="bedNo" width="100" />
      <el-table-column label="入住状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === '0'" type="info">待办理</el-tag>
          <el-tag v-else-if="scope.row.status === '1'" type="warning">办理中</el-tag>
          <el-tag v-else-if="scope.row.status === '2'" type="success">已入住</el-tag>
          <el-tag v-else-if="scope.row.status === '3'" type="danger">已取消</el-tag>
          <el-tag v-else-if="scope.row.status === '4'" type="info">已退住</el-tag>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="入住日期" align="center" prop="checkInDate" width="120">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.checkInDate) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="240">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['admission:checkin:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-circle-check"
            @click="handleConfirm(scope.row)"
            v-hasPermi="['admission:checkin:confirm']"
            v-if="scope.row.status === '0' || scope.row.status === '1'"
          >确认入住</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-close"
            @click="handleCancel(scope.row)"
            v-hasPermi="['admission:checkin:edit']"
            v-if="scope.row.status === '0' || scope.row.status === '1'"
          >取消</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['admission:checkin:remove']"
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
            <el-form-item label="联系电话" prop="phone">
              <el-input v-model="form.phone" placeholder="请输入联系电话" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="年龄" prop="age">
              <el-input v-model.number="form.age" placeholder="请输入年龄" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="性别" prop="gender">
              <el-radio-group v-model="form.gender">
                <el-radio label="0">男</el-radio>
                <el-radio label="1">女</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="入住状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio label="0">待办理</el-radio>
                <el-radio label="1">办理中</el-radio>
                <el-radio label="2">已入住</el-radio>
                <el-radio label="3">已取消</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="护理等级" prop="nursingLevelName">
              <el-input v-model="form.nursingLevelName" placeholder="请输入护理等级" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="护理计划" prop="nursingPlanName">
              <el-input v-model="form.nursingPlanName" placeholder="请输入护理计划" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="楼栋" prop="buildingName">
              <el-input v-model="form.buildingName" placeholder="楼栋" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="房间号" prop="roomNo">
              <el-input v-model="form.roomNo" placeholder="房间号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="床位号" prop="bedNo">
              <el-input v-model="form.bedNo" placeholder="床位号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="入住日期" prop="checkInDate">
              <el-date-picker
                v-model="form.checkInDate"
                type="date"
                placeholder="选择入住日期"
                value-format="yyyy-MM-dd"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="办理人" prop="handler">
              <el-input v-model="form.handler" placeholder="请输入办理人" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="合同开始日期" prop="contractStartDate">
              <el-date-picker
                v-model="form.contractStartDate"
                type="date"
                placeholder="选择开始日期"
                value-format="yyyy-MM-dd"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="合同结束日期" prop="contractEndDate">
              <el-date-picker
                v-model="form.contractEndDate"
                type="date"
                placeholder="选择结束日期"
                value-format="yyyy-MM-dd"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="紧急联系人" prop="emergencyContact">
              <el-input v-model="form.emergencyContact" placeholder="请输入紧急联系人" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="紧急联系电话" prop="emergencyPhone">
              <el-input v-model="form.emergencyPhone" placeholder="请输入紧急联系电话" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="与老人关系" prop="relationship">
              <el-input v-model="form.relationship" placeholder="请输入与老人关系" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="押金(元)" prop="deposit">
              <el-input v-model.number="form.deposit" placeholder="请输入押金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="月费用(元)" prop="monthlyFee">
          <el-input v-model.number="form.monthlyFee" placeholder="请输入月费用" style="width: 30%" />
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
import { listCheckin, getCheckin, delCheckin, addCheckin, updateCheckin, confirmCheckin, cancelCheckin } from "@/api/admission/checkin"

export default {
  name: "Checkin",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      checkinList: [],
      title: "",
      open: false,
      dateRange: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        elderName: undefined,
        status: undefined
      },
      form: {},
      rules: {
        elderName: [
          { required: true, message: "老人姓名不能为空", trigger: "blur" }
        ],
        idCard: [
          { required: true, message: "身份证号不能为空", trigger: "blur" }
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
      listCheckin(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.checkinList = response.rows
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
        checkInNo: undefined,
        elderName: undefined,
        idCard: undefined,
        phone: undefined,
        age: undefined,
        gender: "0",
        status: "0",
        nursingLevelName: undefined,
        nursingPlanName: undefined,
        buildingName: undefined,
        roomNo: undefined,
        bedNo: undefined,
        checkInDate: undefined,
        handler: undefined,
        contractStartDate: undefined,
        contractEndDate: undefined,
        emergencyContact: undefined,
        emergencyPhone: undefined,
        relationship: undefined,
        deposit: undefined,
        monthlyFee: undefined,
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
      this.title = "新建筑住办理"
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    handleUpdate(row) {
      this.reset()
      const id = row.id || this.ids
      getCheckin(id).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改入住办理"
      })
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != undefined) {
            updateCheckin(this.form).then(() => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addCheckin(this.form).then(() => {
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
      this.$modal.confirm('是否确认删除入住编号为"' + (row.checkInNo || ids) + '"的数据项？').then(() => {
        return delCheckin(ids)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleConfirm(row) {
      this.$modal.confirm('是否确认入住编号为"' + row.checkInNo + '"的入住申请？').then(() => {
        return confirmCheckin(row.id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("确认入住成功")
      }).catch(() => {})
    },
    handleCancel(row) {
      this.$modal.confirm('是否取消入住编号为"' + row.checkInNo + '"的入住申请？').then(() => {
        return cancelCheckin(row.id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("取消成功")
      }).catch(() => {})
    },
    handleExport() {
      this.download('admission/checkin/export', {
        ...this.queryParams
      }, `checkin_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>

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
      <el-form-item label="评估状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="评估状态" clearable>
          <el-option label="待评估" value="0" />
          <el-option label="已完成" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item label="评估日期">
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
          v-hasPermi="['admission:assessment:add']"
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
          v-hasPermi="['admission:assessment:edit']"
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
          v-hasPermi="['admission:assessment:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['admission:assessment:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="assessmentList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="评估编号" align="center" prop="assessmentNo" width="120" />
      <el-table-column label="老人姓名" align="center" prop="elderName" :show-overflow-tooltip="true" />
      <el-table-column label="身份证号" align="center" prop="idCard" width="180" />
      <el-table-column label="联系电话" align="center" prop="phone" width="120" />
      <el-table-column label="健康等级" align="center" prop="healthLevel">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.healthLevel === '1'" type="success">自理</el-tag>
          <el-tag v-else-if="scope.row.healthLevel === '2'" type="primary">半自理</el-tag>
          <el-tag v-else-if="scope.row.healthLevel === '3'" type="warning">不能自理</el-tag>
          <el-tag v-else-if="scope.row.healthLevel === '4'" type="danger">特护</el-tag>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="评估状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === '0'" type="warning">待评估</el-tag>
          <el-tag v-else-if="scope.row.status === '1'" type="success">已完成</el-tag>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="评估日期" align="center" prop="assessmentDate" width="120">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.assessmentDate) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['admission:assessment:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-circle-check"
            @click="handleComplete(scope.row)"
            v-hasPermi="['admission:assessment:edit']"
            v-if="scope.row.status === '0'"
          >完成</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['admission:assessment:remove']"
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
            <el-form-item label="评估状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio label="0">待评估</el-radio>
                <el-radio label="1">已完成</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="健康等级" prop="healthLevel">
              <el-select v-model="form.healthLevel" placeholder="请选择健康等级" clearable style="width: 100%">
                <el-option label="自理" value="1" />
                <el-option label="半自理" value="2" />
                <el-option label="不能自理" value="3" />
                <el-option label="特护" value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="评估人" prop="assessor">
              <el-input v-model="form.assessor" placeholder="请输入评估人" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="认知等级" prop="cognitiveLevel">
              <el-select v-model="form.cognitiveLevel" placeholder="请选择认知等级" clearable style="width: 100%">
                <el-option label="正常" value="1" />
                <el-option label="轻度" value="2" />
                <el-option label="中度" value="3" />
                <el-option label="重度" value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="行动能力" prop="mobilityLevel">
              <el-select v-model="form.mobilityLevel" placeholder="请选择行动能力" clearable style="width: 100%">
                <el-option label="正常" value="1" />
                <el-option label="辅助" value="2" />
                <el-option label="轮椅" value="3" />
                <el-option label="卧床" value="4" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="自理能力" prop="selfCareLevel">
          <el-select v-model="form.selfCareLevel" placeholder="请选择自理能力" clearable style="width: 30%">
            <el-option label="完全" value="1" />
            <el-option label="部分" value="2" />
            <el-option label="不能" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="既往病史" prop="medicalHistory">
          <el-input v-model="form.medicalHistory" type="textarea" placeholder="请输入既往病史" />
        </el-form-item>
        <el-form-item label="过敏史" prop="allergyHistory">
          <el-input v-model="form.allergyHistory" type="textarea" placeholder="请输入过敏史" />
        </el-form-item>
        <el-form-item label="评估结论" prop="assessmentConclusion">
          <el-input v-model="form.assessmentConclusion" type="textarea" placeholder="请输入评估结论" />
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
import { listAssessment, getAssessment, delAssessment, addAssessment, updateAssessment, completeAssessment } from "@/api/admission/assessment"

export default {
  name: "Assessment",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      assessmentList: [],
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
      listAssessment(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.assessmentList = response.rows
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
        assessmentNo: undefined,
        elderName: undefined,
        idCard: undefined,
        phone: undefined,
        age: undefined,
        gender: "0",
        status: "0",
        healthLevel: undefined,
        assessor: undefined,
        cognitiveLevel: undefined,
        mobilityLevel: undefined,
        selfCareLevel: undefined,
        medicalHistory: undefined,
        allergyHistory: undefined,
        assessmentConclusion: undefined,
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
      this.title = "新增健康评估"
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    handleUpdate(row) {
      this.reset()
      const id = row.id || this.ids
      getAssessment(id).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改健康评估"
      })
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != undefined) {
            updateAssessment(this.form).then(() => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addAssessment(this.form).then(() => {
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
      this.$modal.confirm('是否确认删除评估编号为"' + (row.assessmentNo || ids) + '"的数据项？').then(() => {
        return delAssessment(ids)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleComplete(row) {
      this.$modal.confirm('是否确认完成编号为"' + row.assessmentNo + '"的评估？').then(() => {
        return completeAssessment(row.id)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("操作成功")
      }).catch(() => {})
    },
    handleExport() {
      this.download('admission/assessment/export', {
        ...this.queryParams
      }, `assessment_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>

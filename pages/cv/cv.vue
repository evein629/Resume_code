
<template>
  <view class="page-container">
    <!-- 左侧简历切换栏 -->
    <scroll-view class="resume-sidebar" scroll-y>
      <view 
        v-for="(resume, index) in resumes" 
        :key="index"
        :class="['resume-card-mini', { active: currentResumeIndex === index }]"
        @tap="switchResume(index)"
      >
        <uni-icons v-if="currentResumeIndex === index" type="checkmarkempty" size="16" color="#2979ff"/>
        <view class="resume-mini-title">{{ resume.title }}</view>
      </view>
    </scroll-view>

    <!-- 主内容区域 -->
    <view class="main-content">
      <!-- 当前简历预览 -->
      <view class="current-resume">
        <view class="resume-header">
          <view class="resume-basic">
            <view class="resume-name">{{ currentResume.name }}</view>
            <view class="resume-title">{{ currentResume.title }}</view>
          </view>
          <view class="resume-exp">
            <uni-text>{{ currentResume.experience }}年经验</uni-text>
            <uni-text>{{ currentResume.education }}</uni-text>
          </view>
        </view>
      </view>

      <!-- 职位筛选区域 -->
      <view class="filter-section">
        <view class="filter-item">
          <uni-data-select
            v-model="filters.jobType"
            :localdata="jobTypes"
            placeholder="岗位类型"
            @change="handleFilterChange"
          />
        </view>
        <view class="filter-item">
          <uni-data-select
            v-model="filters.city"
            :localdata="cities"
            placeholder="城市"
            @change="handleFilterChange"
          />
        </view>
        <view class="filter-item">
          <uni-data-select
            v-model="filters.salary"
            :localdata="salaryRanges"
            placeholder="薪资范围"
            @change="handleFilterChange"
          />
        </view>
      </view>

      <!-- 匹配职位列表 -->
      <scroll-view 
        class="job-list" 
        scroll-y 
        @scrolltolower="loadMoreJobs"
        @refresherrefresh="onRefresh"
        refresher-enabled
        :refresher-triggered="isRefreshing"
      >
        <view 
          v-for="(job, index) in matchedJobs" 
          :key="index"
          class="job-card cursor-pointer"
          @tap="goToJobDetail(job)"
        >
          <view class="job-card-header">
            <image class="company-logo" :src="job.companyLogo" mode="aspectFit"/>
            <view class="job-basic">
              <view class="job-title">{{ job.title }}</view>
              <view class="company-name">{{ job.companyName }}</view>
            </view>
            <view class="job-salary">{{ job.salary }}</view>
          </view>
          <view class="job-tags">
            <uni-tag v-for="(tag, tIndex) in job.tags" :key="tIndex" :text="tag" size="small"/>
          </view>
        </view>
      </scroll-view>
    </view>

    <!-- 职位详情弹窗 -->
    <uni-popup ref="jobDetailPopup" type="right">
      <view class="job-detail-container">
        <view class="detail-header">
          <uni-icons type="back" size="24" @tap="closeJobDetail"/>
          <view class="detail-title">职位详情</view>
        </view>
        
        <scroll-view class="detail-content" scroll-y>
          <view class="detail-company">
            <image :src="selectedJob?.companyLogo" mode="aspectFit" class="detail-company-logo"/>
            <view class="detail-company-info">
              <view class="detail-job-title">{{ selectedJob?.title }}</view>
              <view class="detail-company-name">{{ selectedJob?.companyName }}</view>
              <view class="detail-salary">{{ selectedJob?.salary }}</view>
            </view>
          </view>

          <view class="action-buttons">
            <button class="optimize-btn" @tap="optimizeResume">优化简历</button>
            <button class="boss-link-btn" @tap="openBossLink">
              <uni-icons type="forward" size="16"/>
              打开BOSS直聘
            </button>
          </view>

          <view class="detail-section">
            <view class="section-title">职位要求</view>
            <view class="section-content">{{ selectedJob?.requirements }}</view>
          </view>

          <view class="detail-section">
            <view class="section-title">公司信息</view>
            <view class="section-content">{{ selectedJob?.companyInfo }}</view>
          </view>
        </scroll-view>
      </view>
    </uni-popup>

    <!-- 简历优化弹窗 -->
    <uni-popup ref="optimizePopup" type="center">
      <view class="optimize-container">
        <view class="optimize-header">
          <view class="optimize-title">简历优化</view>
          <uni-icons type="closeempty" size="24" @tap="closeOptimize"/>
        </view>
        <view class="optimize-content">
          <view class="optimize-status">
            <uni-icons type="refresh" size="24" :class="{ 'rotating': isOptimizing }"/>
            <view class="optimize-text">{{ optimizeStatus }}</view>
          </view>
          <button 
            class="save-optimize-btn" 
            :disabled="!optimizedContent"
            @tap="saveOptimizedResume"
          >
            保存优化结果
          </button>
        </view>
      </view>
    </uni-popup>
  </view>
</template>

<script lang="ts" setup>
import { ref, computed } from 'vue';

const resumes = ref([
  {
    id: 1,
    name: '张三',
    title: '高级前端开发工程师',
    experience: '5',
    education: '本科',
  },
  {
    id: 2,
    name: '张三',
    title: '前端架构师',
    experience: '5',
    education: '本科',
  }
]);

const currentResumeIndex = ref(0);
const currentResume = computed(() => resumes.value[currentResumeIndex.value]);

const filters = ref({
  jobType: '',
  city: '',
  salary: ''
});

const jobTypes = ref([
  { value: '1', text: '前端开发' },
  { value: '2', text: '后端开发' },
  { value: '3', text: '全栈开发' },
  { value: '4', text: '架构师' }
]);

const cities = ref([
  { value: '1', text: '北京' },
  { value: '2', text: '上海' },
  { value: '3', text: '广州' },
  { value: '4', text: '深圳' }
]);

const salaryRanges = ref([
  { value: '1', text: '15k以下' },
  { value: '2', text: '15k-25k' },
  { value: '3', text: '25k-35k' },
  { value: '4', text: '35k以上' }
]);

const matchedJobs = ref([
  {
    id: 1,
    title: '资深前端开发工程师',
    companyName: '科技有限公司',
    companyLogo: 'https://public.readdy.ai/ai/img_res/e45a348ddd55ffb2dc7fa0303e13e959.jpg',
    salary: '25k-35k',
    tags: ['React', 'Vue', 'TypeScript'],
    requirements: '1. 精通前端开发技术\n2. 具有良好的代码风格\n3. 熟悉前端工程化',
    companyInfo: '我们是一家快速发展的科技公司，专注于前沿技术研发，提供具有竞争力的薪资福利。'
  },
  {
    id: 2,
    title: '前端架构师',
    companyName: '互联网科技',
    companyLogo: 'https://public.readdy.ai/ai/img_res/18cd21f7a3d7a1e8fa798714cd3f1197.jpg',
    salary: '35k-50k',
    tags: ['架构设计', '技术管理', '前端工程化'],
    requirements: '1. 负责前端架构设计\n2. 带领团队进行技术攻关\n3. 制定技术规范',
    companyInfo: '专注于企业级解决方案，工作环境舒适，团队氛围活跃。'
  }
]);

const jobDetailPopup = ref();
const optimizePopup = ref();
const selectedJob = ref();
const isRefreshing = ref(false);
const isOptimizing = ref(false);
const optimizeStatus = ref('准备优化...');
const optimizedContent = ref('');

const handleFilterChange = () => {
  refreshJobs();
};

const switchResume = (index: number) => {
  currentResumeIndex.value = index;
  refreshJobs();
};

const goToJobDetail = (job: any) => {
  selectedJob.value = job;
  jobDetailPopup.value.open();
};

const closeJobDetail = () => {
  jobDetailPopup.value.close();
};

const loadMoreJobs = () => {
  // 加载更多职位
};

const onRefresh = () => {
  isRefreshing.value = true;
  setTimeout(() => {
    refreshJobs();
    isRefreshing.value = false;
  }, 1000);
};

const refreshJobs = () => {
  // 刷新职位列表
};

const optimizeResume = () => {
  isOptimizing.value = true;
  optimizeStatus.value = '正在优化...';
  optimizePopup.value.open();
  
  setTimeout(() => {
    isOptimizing.value = false;
    optimizeStatus.value = '优化完成';
    optimizedContent.value = '优化后的简历内容';
  }, 2000);
};

const closeOptimize = () => {
  optimizePopup.value.close();
};

const saveOptimizedResume = () => {
  uni.showToast({
    title: '保存成功',
    icon: 'success'
  });
  closeOptimize();
};

const openBossLink = () => {
  uni.showModal({
    title: '提示',
    content: '即将打开BOSS直聘',
    success: (res) => {
      if (res.confirm) {
        // 打开BOSS直聘链接
      }
    }
  });
};
</script>

<style>
page {
  height: 100%;
}

.page-container {
  display: flex;
  height: 100%;
}

.resume-sidebar {
  width: 100rpx;
  height: 100%;
  background-color: #f8f8f8;
  border-right: 1px solid #eee;
  flex-shrink: 0;
}

.resume-card-mini {
  padding: 20rpx 10rpx;
  text-align: center;
  border-bottom: 1px solid #eee;
  position: relative;
}

.resume-card-mini.active {
  background-color: #fff;
  border-left: 4rpx solid #2979ff;
}

.resume-mini-title {
  font-size: 12px;
  color: #666;
  margin-top: 10rpx;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  height: 100%;
}

.current-resume {
  padding: 30rpx;
  background-color: #fff;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  flex-shrink: 0;
}

.resume-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.resume-name {
  font-size: 20px;
  font-weight: bold;
  color: #333;
}

.resume-title {
  font-size: 14px;
  color: #666;
  margin-top: 10rpx;
}

.resume-exp {
  text-align: right;
  font-size: 14px;
  color: #999;
}

.filter-section {
  padding: 20rpx;
  background-color: #fff;
  display: flex;
  gap: 20rpx;
  flex-shrink: 0;
}

.filter-item {
  flex: 1;
}

.job-list {
  flex: 1;
  overflow: auto;
  padding: 20rpx;
}

.job-card {
  background-color: #fff;
  border-radius: 12rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.job-card-header {
  display: flex;
  align-items: center;
}

.company-logo {
  width: 80rpx;
  height: 80rpx;
  border-radius: 8rpx;
  margin-right: 20rpx;
}

.job-basic {
  flex: 1;
}

.job-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.company-name {
  font-size: 14px;
  color: #666;
  margin-top: 10rpx;
}

.job-salary {
  font-size: 16px;
  color: #ff6b81;
  font-weight: bold;
}

.job-tags {
  margin-top: 20rpx;
  display: flex;
  flex-wrap: wrap;
  gap: 10rpx;
}

.job-detail-container {
  width: 600rpx;
  height: 100%;
  background-color: #fff;
}

.detail-header {
  padding: 30rpx;
  display: flex;
  align-items: center;
  border-bottom: 1px solid #eee;
}

.detail-title {
  flex: 1;
  text-align: center;
  font-size: 16px;
  font-weight: bold;
}

.detail-content {
  height: calc(100% - 88rpx);
  padding: 30rpx;
}

.detail-company {
  display: flex;
  align-items: flex-start;
  margin-bottom: 40rpx;
}

.detail-company-logo {
  width: 120rpx;
  height: 120rpx;
  border-radius: 12rpx;
  margin-right: 30rpx;
}

.detail-company-info {
  flex: 1;
}

.detail-job-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.detail-company-name {
  font-size: 14px;
  color: #666;
  margin-top: 10rpx;
}

.detail-salary {
  font-size: 18px;
  color: #ff6b81;
  font-weight: bold;
  margin-top: 10rpx;
}

.action-buttons {
  display: flex;
  gap: 20rpx;
  margin: 40rpx 0;
}

.optimize-btn {
  flex: 1;
  background-color: #2979ff;
  color: #fff;
}

.boss-link-btn {
  flex: 1;
  background-color: #ff6b81;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
}

.detail-section {
  margin-bottom: 40rpx;
}

.section-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.section-content {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
}

.optimize-container {
  width: 600rpx;
  background-color: #fff;
  border-radius: 12rpx;
  padding: 30rpx;
}

.optimize-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.optimize-title {
  font-size: 16px;
  font-weight: bold;
}

.optimize-content {
  padding: 40rpx 0;
}

.optimize-status {
  text-align: center;
  margin-bottom: 40rpx;
}

.optimize-text {
  margin-top: 20rpx;
  color: #666;
}

.save-optimize-btn {
  background-color: #2979ff;
  color: #fff;
}

.rotating {
  animation: rotate 1s linear infinite;
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.cursor-pointer {
  cursor: pointer;
}
</style>


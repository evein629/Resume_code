<template>
	<view class="container">
		<view class="header">
			<text class="title">简历优化助手</text>
			<text class="subtitle">帮助你找到理想的工作</text>
		</view>
		
		<view class="content">
			<view class="card">
				<view class="card-title">开始使用</view>
				<view class="card-text">
					<text>欢迎使用简历优化助手，点击下方按钮开始匹配职位并优化你的简历。</text>
				</view>
				<button class="primary-button" @tap="navigateToCv">开始匹配职位</button>
			</view>
			
			<view class="features">
				<view class="feature-item">
					<uni-icons type="checkmarkempty" size="24" color="#2979ff"/>
					<text class="feature-text">智能简历匹配</text>
				</view>
				<view class="feature-item">
					<uni-icons type="star" size="24" color="#2979ff"/>
					<text class="feature-text">职位精准推荐</text>
				</view>
				<view class="feature-item">
					<uni-icons type="paperplane" size="24" color="#2979ff"/>
					<text class="feature-text">一键优化简历</text>
				</view>
			</view>
		</view>
	</view>
</template>

<script setup>
const navigateToCv = () => {
	// 尝试不同的导航方式
	uni.navigateTo({
		url: '/pages/cv/cv'
	});
	
	// 如果上面不行，可以尝试取消下面的注释
	// setTimeout(() => {
	//   uni.reLaunch({
	//     url: '/pages/cv/cv'
	//   });
	// }, 100);
};
</script>

<style>
	.container {
		padding: 40rpx;
		min-height: 100vh;
		background-color: #f8f9fa;
	}

	.header {
		margin-bottom: 60rpx;
		text-align: center;
	}

	.title {
		font-size: 48rpx;
		font-weight: bold;
		color: #333;
		margin-bottom: 20rpx;
		display: block;
	}

	.subtitle {
		font-size: 28rpx;
		color: #666;
		display: block;
	}

	.card {
		background-color: #fff;
		border-radius: 16rpx;
		padding: 40rpx;
		margin-bottom: 40rpx;
		box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.1);
	}

	.card-title {
		font-size: 36rpx;
		font-weight: bold;
		color: #333;
		margin-bottom: 20rpx;
	}

	.card-text {
		font-size: 28rpx;
		color: #666;
		margin-bottom: 40rpx;
		line-height: 1.6;
	}

	.primary-button {
		background-color: #2979ff;
		color: #fff;
		border-radius: 40rpx;
		padding: 20rpx;
		font-size: 32rpx;
		font-weight: bold;
	}

	.features {
		margin-top: 60rpx;
	}

	.feature-item {
		display: flex;
		align-items: center;
		margin-bottom: 30rpx;
	}

	.feature-text {
		font-size: 30rpx;
		color: #333;
		margin-left: 20rpx;
	}
</style>

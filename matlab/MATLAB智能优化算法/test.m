%% 高斯双峰 GPT生成
% 设置参数
x = linspace(-5, 5, 1000);  % x轴范围
mu1 = -2;                   % 第一个峰的均值
sigma1 = 1;                 % 第一个峰的标准差
amp1 = 0.8;                 % 第一个峰的高度

mu2 = 2;                    % 第二个峰的均值
sigma2 = 1.5;               % 第二个峰的标准差
amp2 = 0.5;                 % 第二个峰的高度

% 计算高斯分布
y1 = amp1 * exp(-(x - mu1).^2 / (2 * sigma1^2));
y2 = amp2 * exp(-(x - mu2).^2 / (2 * sigma2^2));

% 叠加两个峰
y = y1 + y2;

% 绘图
figure(Color=[1 1 1]);
plot(x, y1, '--', 'LineWidth', 2, 'DisplayName', 'Gaussian 1');
hold on;
plot(x, y2, '--', 'LineWidth', 2, 'DisplayName', 'Gaussian 2');
plot(x, y, 'LineWidth', 2, 'DisplayName', 'Sum of Gaussians');
legend();
xlabel('X');
ylabel('Y');
title('Gaussian Bimodal Distribution');
grid on;

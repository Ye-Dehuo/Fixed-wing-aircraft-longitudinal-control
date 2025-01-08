clc
clear all
close all

%% ��ģ

% ���͹̶����������
W = 12224;
I_x = 1420.9; 
I_y = 4067.5;
I_z = 4786.0;
I_xz = 0;
S = 17.1;          
c = 1.74;  
b = 10.18; 
V_co = 122;

% �������в���
Ma = 0.158;                               
C_L_star = 0.41;
C_D_star = 0.05;
C_L_alpha = 4.44;
C_D_alpha = 0.33;
C_m_alpha = -0.683;
C_L_V = 0;                 
C_D_V = 0;
C_m_V = 0;
C_L_dot_alpha = 0;
C_z_dot_alpha = 0; 
C_m_dot_alpha = -4.36;
C_L_q = 3.80;
C_z_q = -3.80;
C_m_q = -9.96;
C_L_delta_e = 0.355;
C_z_delta_e = -0.355;
C_D_delta_e = 0;
C_m_delta_e = -0.923;
T_V = 0;
g = 9.81;
rho = 1.225;
gamma_star = 0;

% ��������
m = W / g;
V_star = 340 * Ma;
q_star = rho * (V_star)^2/2;
K_alpha = C_L_alpha*q_star*S/W;
K_q = V_co/g;
C_star_ss = 2;

% ������ѧ����
X_V = -((C_D_V + 2 * C_D_star) * q_star * S) / (m * V_star);                                 
X_alpha = -8.1231;                     
X_delta_e = -C_D_delta_e * (q_star * S) / m;                                    

Z_V = (C_L_V + 2 * C_L_star) * q_star * S / (m * V_star^2);                               
Z_alpha = ((C_D_star + C_L_alpha) * q_star * S) / (m * V_star);                                    
Z_delta_e = C_L_delta_e * (q_star * S) / (m * V_star);                        

M_bar_V = (C_m_V * q_star * S * c) / (V_star * I_y);                               
M_bar_alpha = C_m_alpha * (q_star * S * c) / I_y;
M_bar_dot_alpha = C_m_dot_alpha * (c / (2 * V_star)) * q_star * S * c / I_y;
M_bar_q = C_m_q * (c / (2 * V_star)) * q_star * S * c / I_y;
M_bar_delta_e = C_m_delta_e * (q_star * S * c) / I_y;

% ������״̬�ռ�ģ��
A = [
    -Z_alpha, 1;
    M_bar_alpha - M_bar_dot_alpha * Z_alpha, M_bar_q + M_bar_dot_alpha
    ];

B = [
    -Z_delta_e;
    M_bar_delta_e - M_bar_dot_alpha * Z_delta_e
    ];

C = eye(2);% �������Ϊ����״̬����

D = [0;
     0]; % û��ֱ�ӵĿ������뵽�����Ӱ��

 % ��ʼ����
 sim('shortPeriodSimulink');
 
%% ���켣����

% �����������ݺ���
num = [1 3.017 0.563];
den = [1 5.226 14.065 2.612 0];
K_G_star = 14.84; % ǰ��ͨ�����켣����
K_H_star = 1; % ����ͨ�����켣����
K_star = K_G_star * K_H_star; % ���켣����
sys_ol = K_star*tf(num, den); % �������ݺ���

% ���Ƹ��켣
figure('Name','Root locus')
rlocus(sys_ol);

%% �ȶ�ԣ�ȷ���

% �����ο�˹��ͼ
figure('Name','Nyguist Plot')
nyquist(sys_ol);

% ����Bodeͼ
figure('Name','Bode Plot')
bode(sys_ol);

% ��ֵԣ�� ���ԣ��
[Gm,Pm,Wgm,Wpm] = margin(sys_ol); 

%% ����Ʒ�ʷ���

sys_cl = feedback(sys_ol, 1); % �ջ����ݺ�����KP = 0.5�� KI = 0.1��

[Wn, Zeta, Pole] = damp(sys_cl); % �ջ�ϵͳƵ�ʣ�����ȣ�����

T = 1 / Wn(2); % һ��ϵͳʱ�䳣��
omega_n = Wn(3); % Ƿ����ϵͳ��ȻƵ�ʣ��ܿغ������ģ̬��ȻƵ�ʣ�
zeta = Zeta(3); % Ƿ����ϵͳ����ȣ��ܿغ������ģ̬����ȣ�
CAP = omega_n ^2 / ((V_star / g) * Z_alpha); % ������������

% ����C*ָ��ͼ
C_star_0 = ones(size(t));
C_star_index = (Delta_C_star + C_star_0) / C_star_ss;
figure('name','C*ָ��')
plot(t, C_star_index, t, upperBound, t, lowerBound);
xlabel('$t/\mathrm{s}$','interpreter','latex');
ylabel('$C^*/C^*_\infty$','interpreter','latex');
grid on;

%% ʱ�����Է���

% ����ʱ��
tr_1 = 2.2 * T;
tr_2 = (pi - acos(zeta))/(omega_n * sqrt(1 - zeta ^2));

% ��ֵʱ��
tp_2 = pi / (omega_n * sqrt(1 - zeta ^2));

% ������
sigma_2 = exp(-pi*zeta/sqrt(1-zeta^2)); 

% ����ʱ��
ts_1 = 3 * T;
ts_2 = 3.5/(zeta * omega_n);
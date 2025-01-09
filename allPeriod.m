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

% ״̬�ռ�ģ��
A = [
    X_V, X_alpha + g*cos(gamma_star), 0, -g*cos(gamma_star);
    -Z_V, -Z_alpha + (g*sin(gamma_star)/V_star), 1, -(g*sin(gamma_star)/V_star);
    M_bar_V - M_bar_dot_alpha * Z_V, M_bar_alpha - M_bar_dot_alpha * (Z_alpha - (g*sin(gamma_star)/V_star)), M_bar_q + M_bar_dot_alpha, -M_bar_dot_alpha * (g*sin(gamma_star)/V_star);
    0, 0, 1, 0
];

B = [
    X_delta_e;
    -Z_delta_e;
    M_bar_delta_e - M_bar_dot_alpha * Z_delta_e;
    0
];

C = eye(4); % �������Ϊ����״̬����
D = zeros(4, 1);  % û��ֱ�ӵĿ������뵽�����Ӱ��

% ����״̬�ռ����
sys = ss(A, B, C, D);

%% ģ̬����

% ���������
eigValues = eig(A); % ϵͳ������
eta_sp = real(eigValues(1)); % ������ģ̬��Ӧ��������ʵ��
eta_p = real(eigValues(3)); % ������ģ̬��Ӧ��������ʵ��

% ������ģ̬��ȡ����ģ�ͣ�
omega_n_sp = sqrt(-(M_bar_alpha+M_bar_q*Z_alpha)); % ��ȻƵ��
zeta_sp = -(M_bar_q+M_bar_dot_alpha-Z_alpha)/(2*omega_n_sp); % �����
t_12 = -log(2)/eta_sp; % ��˥��
N_12 = log(2)*sqrt(1-zeta_sp^2)/(2*pi*zeta_sp); % ��˥�����񵴴���
omega_sp = omega_n_sp*sqrt(1-zeta_sp^2); % ������Ƶ��
T_sp = 2*pi/omega_sp; % ����

% ������ģ̬
omega_p = imag(eigValues(3)); % ������Ƶ��
T_p = 2*pi/omega_p; % ����
omega_n_p = sqrt(eta_p^2+omega_p^2); % ��ȻƵ��
zeta_p = -eta_p/omega_n_p; % �����
t_2 = -log(2)/eta_p; % ����ʱ
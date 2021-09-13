%                       _oo0oo_
%                      o8888888o
%                      88" . "88
%                      (| -_- |)
%                      0\  =  /0
%                    ___/`---'\___
%                  .' \\|     |// '.
%                 / \\|||  :  |||// \
%                / _||||| -:- |||||- \
%               |   | \\\  -  /// |   |
%               | \_|  ''\---/''  |_/ |
%               \  .-\__  '-'  ___/-. /
%             ___'. .'  /--.--\  `. .'___
%          ."" '<  `.___\_<|>_/___.' >' "".
%         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
%         \  \ `_.   \_ __\ /__ _/   .-` /  /
%     =====`-.____`.___ \_____/___.-`___.-'=====
%                       `=---='
%
%
%     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
%               ���汣��         ����BUG


clc;
clear;
close all; 
file=dir('F:\matlab_project\2021.07.12_Contour_Figure\Data-csv\*.csv');  %�����ļ��ĵ�ַ
n_max = length(file);
% fr_x_0 = importdata('Axis-201205-yz_x.txt');  %x������ֵ
% fr_y_0 = importdata('Axis-201205-yz_z.txt');  %y������ֵ
% n_max_x = length(fr_x_0);
% n_max_y = length(fr_y_0);

X_1 = 2; X_2 = 498; %������ѡȡ�Ĳ�����Χ��С/��ֵ��λ�ã���ԭ���ݵĵ�һ����  WS2 2-498  MoS2 2-595
Y_1 = 2; Y_2 = 195; %ѡȡ������ֹ�� ��0-272�� % ѡȡ
Wave_1 = 550; Wave_2 = 720;   % ѡȡscale bar �������޲����ж���Χ

for n =1:n_max
     strposition = strfind(file(n).name, '-WS2');  % �ؼ���ѡȡ
  if ~isempty (strposition)
     
     A = file(n).name;     
     fr_A_0 = readmatrix(file(n).name);     % �������ļ����� ��csv��ʽ��
     fr_A_0(find(isnan(fr_A_0)==1)) = 0;    % Ѱ�Ҳ��Զ�'Nan'�滻Ϊ'0' ^^^^
     % fr_Ex_1 = fr_Ex_0';

     %%����
        [X,Y] = size (fr_A_0(:,2:end));
     
        fr_x_0 = fr_A_0(X_1:X_2,1);         % x������ֵ��ԭ���ݵĵ�һ���У�������
        fr_y_0 = fr_A_0(1,Y_1:Y);         % y������ֵ��ԭ���ݵĵ�һ���У�����ʱ��
        fr_A_0 = fr_A_0(X_1:X_2,Y_1:Y);
        fr_A_0 = fr_A_0.* 1000;             % ��Aǿ��
        
        xx_res = length(fr_x_0);            % x������ֱ���
        yy_res = length(fr_y_0);            % y������ֱ���
        n_max_res = xx_res * yy_res;        % ����ֵ���� 
          
    %%ת��
        fr_A_one = ones(size(fr_A_0));      % ������Ex��ͬ�ṹ��ȫ1����
        % fr_x_1 = fr_x_0' * fr_Ex_one;
        fr_x_1 = fr_A_one' .* fr_x_0';
        fr_y_1 = fr_y_0' .* (fr_A_one)';
        fr_A_1 = fr_A_0';
        fr_x_2 = reshape(fr_x_1,n_max_res,1);
        fr_y_2 = reshape(fr_y_1,n_max_res,1);
        fr_A_2 = reshape(fr_A_1,n_max_res,1);

   %%��ͼ        
      figure
      %yy_region = fr_x_0 * fr_Ex_one fr_x_0;
      yy_region = fr_x_1;
      xx_region = fr_y_1;
      zz_region = fr_A_1;
      pcolor(yy_region,xx_region,zz_region);shading interp%α��ɫͼ
      set(gcf,'Colormap',parula)
          grid on
          set(gca, 'tickdir', 'out')
          xlim([420 770])
          ylim([-3 2000]) 
          xlabel('Wavelength (nm)','FontName','Arial','FontSize',12);
          ylabel('Delay time (ps)','FontName','Arial','FontSize',12);%����xy���ǩ���ݺ�����
          set(gca, 'Fontname', 'Arial', 'Fontsize', 12);%����xy����������ͺ��ֺŴ�С��
          set(gca,'Position',[.18 .17 .6 .75]);%���������xy����ͼƬ��ռ�ı�����������Ҫ�Լ�΢����
                
      if (0)
         %%����λ����ȡ������Сֵ 
         [~,Wave_Pos_1]=min(abs(fr_x_0(:) - Wave_1));   % Ѱ�����Wave_1������λ��   
         [~,Wave_Pos_2]=min(abs(fr_x_0(:) - Wave_2));   % Ѱ�����Wave_2������λ��   
         Zmax = max( max( fr_A_0(Wave_Pos_1:Wave_Pos_2,:)));  %ѡȡ Wave_1~Wave_2������Χ�ڵ����ֵ
         Zmin = min( min( fr_A_0(Wave_Pos_1:Wave_Pos_2,:)));  %ѡȡ Wave_1~Wave_2������Χ�ڵ���Сֵ
         set(gca,'CLim',[Zmin Zmax]);  %����color bar ��ʾ��Χ
      
      set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);%����ǽ��߿��Ϊ2
      set(gca,'Ytick',[0.1, 1, 10, 100, 1000 ]);
      set(gca,'yscale','log');
      set(gca,'Xtick',[400:100:770]);
      set(gcf,'Position',[100 100 400 320]);%��������û�ͼ�Ĵ�С������Ҫ��word���ٵ�����С���Ҹ��Ĳ�����ͼ�Ĵ�С��7cm
      colorbar('position',[0.82 0.17 0.035 0.75]); %���ò�ɫ����λ�úʹ�С
      
          print([num2str(file(n).name),'.tif'] ,'-dtiffn','-r300');
      end   
    
      %%��ȡdeltaA������Ϣ
         Delay = [-0.2, 0.5, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];
         if(1)
                  %Delay1
         Delay_1 = Delay (1,1);
         [~,Delay_1_1]=min(abs(fr_y_0(:) - Delay_1));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_1 = fr_A_1(Delay_1_1,:); Spec_1 = [Delay_1, fr_y_0(1,Delay_1_1), Spec_1];  % Ѱ�����ӦDelay_1ʱ��Ĺ���    
                  %Delay2
         Delay_2 = Delay (1,2);
         [~,Delay_2_1]=min(abs(fr_y_0(:) - Delay_2));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_2 = fr_A_1(Delay_2_1,:); Spec_2 = [Delay_2, fr_y_0(1,Delay_2_1), Spec_2];  % Ѱ�����ӦDelay_1ʱ��Ĺ���   
                  %Delay3
         Delay_3 = Delay (1,3);
         [~,Delay_3_1]=min(abs(fr_y_0(:) - Delay_3));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_3 = fr_A_1(Delay_3_1,:); Spec_3 = [Delay_3, fr_y_0(1,Delay_3_1), Spec_3];  % Ѱ�����ӦDelay_1ʱ��Ĺ���   
                  %Delay4
         Delay_4 = Delay (1,4);
         [~,Delay_4_1]=min(abs(fr_y_0(:) - Delay_4));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_4 = fr_A_1(Delay_1_1,:); Spec_4 = [Delay_4, fr_y_0(1,Delay_4_1), Spec_4];  % Ѱ�����ӦDelay_1ʱ��Ĺ���   
                  %Delay5
         Delay_5 = Delay (1,5);
         [~,Delay_5_1]=min(abs(fr_y_0(:) - Delay_5));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_5 = fr_A_1(Delay_5_1,:); Spec_5 = [Delay_5, fr_y_0(1,Delay_5_1), Spec_5];  % Ѱ�����ӦDelay_1ʱ��Ĺ���   
                  %Delay6
         Delay_6 = Delay (1,6);
         [~,Delay_6_1]=min(abs(fr_y_0(:) - Delay_6));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_6 = fr_A_1(Delay_6_1,:); Spec_6 = [Delay_6, fr_y_0(1,Delay_6_1), Spec_6];  % Ѱ�����ӦDelay_1ʱ��Ĺ���   
                  %Delay7
         Delay_7 = Delay (1,7);
         [~,Delay_7_1]=min(abs(fr_y_0(:) - Delay_7));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_7 = fr_A_1(Delay_7_1,:); Spec_7 = [Delay_7, fr_y_0(1,Delay_7_1), Spec_7];  % Ѱ�����ӦDelay_1ʱ��Ĺ���   
                  %Delay8
         Delay_8 = Delay (1,8);
         [~,Delay_8_1]=min(abs(fr_y_0(:) - Delay_8));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_8 = fr_A_1(Delay_8_1,:); Spec_8 = [Delay_8, fr_y_0(1,Delay_8_1), Spec_8];  % Ѱ�����ӦDelay_1ʱ��Ĺ���   
                  %Delay9
         Delay_9 = Delay (1,9);
         [~,Delay_9_1]=min(abs(fr_y_0(:) - Delay_9));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_9 = fr_A_1(Delay_9_1,:); Spec_9 = [Delay_9, fr_y_0(1,Delay_9_1), Spec_9];  % Ѱ�����ӦDelay_1ʱ��Ĺ���  
                  %Delay10
         Delay_10 = Delay (1,10);
         [~,Delay_10_1]=min(abs(fr_y_0(:) - Delay_10));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_10 = fr_A_1(Delay_10_1,:); Spec_10 = [Delay_10, fr_y_0(1,Delay_10_1), Spec_10];  % Ѱ�����ӦDelay_1ʱ��Ĺ���           
                  %Delay11
         Delay_11 = Delay (1,11);
         [~,Delay_11_1]=min(abs(fr_y_0(:) - Delay_11));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_11 = fr_A_1(Delay_11_1,:); Spec_11 = [Delay_11, fr_y_0(1,Delay_11_1), Spec_11];  % Ѱ�����ӦDelay_1ʱ��Ĺ���
                  %Delay12
         Delay_12 = Delay (1,12);
         [~,Delay_12_1]=min(abs(fr_y_0(:) - Delay_12));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_12 = fr_A_1(Delay_12_1,:); Spec_12 = [Delay_12, fr_y_0(1,Delay_12_1), Spec_12];  % Ѱ�����ӦDelay_1ʱ��Ĺ���  
                  %Delay13
         Delay_13 = Delay (1,13);
         [~,Delay_13_1]=min(abs(fr_y_0(:) - Delay_13));               % Ѱ�����Delay_1ʱ���λ��        
         Spec_13 = fr_A_1(Delay_13_1,:); Spec_13 = [Delay_13, fr_y_0(1,Delay_13_1), Spec_13];  % Ѱ�����ӦDelay_1ʱ��Ĺ���  
         end
         Wavelength = [0,0,fr_x_0'];
         Spectra = [Wavelength;Spec_1;Spec_2;Spec_3;Spec_4;Spec_5;Spec_6;Spec_7;Spec_8;Spec_9;Spec_10;Spec_11;Spec_12;Spec_13];
         Spectra_1 = Spectra';
         save(file(n).name,'Spectra_1','-ascii');
         
          
         %Zmax = max( max( fr_A_0(Wave_Pos_1:Wave_Pos_2,:)));  %ѡȡ Wave_1~Wave_2������Χ�ڵ����ֵ
         %Zmin = min( min( fr_A_0(Wave_Pos_1:Wave_Pos_2,:)));  %ѡȡ Wave_1~Wave_2������Χ�ڵ���Сֵ
         %set(gca,'CLim',[Zmin Zmax]);  %����color bar ��ʾ��Χ
      
  end
end
        
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
%               佛祖保佑         永无BUG


clc;
clear;
close all; 
file=dir('F:\matlab_project\2021.07.12_Contour_Figure\Data-csv\*.csv');  %处理文件的地址
n_max = length(file);
% fr_x_0 = importdata('Axis-201205-yz_x.txt');  %x轴坐标值
% fr_y_0 = importdata('Axis-201205-yz_z.txt');  %y轴坐标值
% n_max_x = length(fr_x_0);
% n_max_y = length(fr_y_0);

X_1 = 2; X_2 = 498; %代表了选取的波长范围最小/大值的位置，在原数据的第一列中  WS2 2-498  MoS2 2-595
Y_1 = 2; Y_2 = 195; %选取数据起止行 （0-272） % 选取
Wave_1 = 550; Wave_2 = 720;   % 选取scale bar 的上线限波长判定范围

for n =1:n_max
     strposition = strfind(file(n).name, '-WS2');  % 关键字选取
  if ~isempty (strposition)
     
     A = file(n).name;     
     fr_A_0 = readmatrix(file(n).name);     % 导入主文件数据 （csv格式）
     fr_A_0(find(isnan(fr_A_0)==1)) = 0;    % 寻找并自动'Nan'替换为'0' ^^^^
     % fr_Ex_1 = fr_Ex_0';

     %%导入
        [X,Y] = size (fr_A_0(:,2:end));
     
        fr_x_0 = fr_A_0(X_1:X_2,1);         % x轴坐标值，原数据的第一行中，代表波长
        fr_y_0 = fr_A_0(1,Y_1:Y);         % y轴坐标值，原数据的第一列中，代表时间
        fr_A_0 = fr_A_0(X_1:X_2,Y_1:Y);
        fr_A_0 = fr_A_0.* 1000;             % ΔA强度
        
        xx_res = length(fr_x_0);            % x轴坐标分辨率
        yy_res = length(fr_y_0);            % y轴坐标分辨率
        n_max_res = xx_res * yy_res;        % 总数值个数 
          
    %%转换
        fr_A_one = ones(size(fr_A_0));      % 构建和Ex相同结构的全1矩阵
        % fr_x_1 = fr_x_0' * fr_Ex_one;
        fr_x_1 = fr_A_one' .* fr_x_0';
        fr_y_1 = fr_y_0' .* (fr_A_one)';
        fr_A_1 = fr_A_0';
        fr_x_2 = reshape(fr_x_1,n_max_res,1);
        fr_y_2 = reshape(fr_y_1,n_max_res,1);
        fr_A_2 = reshape(fr_A_1,n_max_res,1);

   %%画图        
      figure
      %yy_region = fr_x_0 * fr_Ex_one fr_x_0;
      yy_region = fr_x_1;
      xx_region = fr_y_1;
      zz_region = fr_A_1;
      pcolor(yy_region,xx_region,zz_region);shading interp%伪彩色图
      set(gcf,'Colormap',parula)
          grid on
          set(gca, 'tickdir', 'out')
          xlim([420 770])
          ylim([-3 2000]) 
          xlabel('Wavelength (nm)','FontName','Arial','FontSize',12);
          ylabel('Delay time (ps)','FontName','Arial','FontSize',12);%设置xy轴标签内容和字体
          set(gca, 'Fontname', 'Arial', 'Fontsize', 12);%设置xy轴的字体类型和字号大小的
          set(gca,'Position',[.18 .17 .6 .75]);%这句是设置xy轴在图片中占的比例，可能需要自己微调。
                
      if (0)
         %%根据位置提取最大和最小值 
         [~,Wave_Pos_1]=min(abs(fr_x_0(:) - Wave_1));   % 寻找最靠近Wave_1波长的位置   
         [~,Wave_Pos_2]=min(abs(fr_x_0(:) - Wave_2));   % 寻找最靠近Wave_2波长的位置   
         Zmax = max( max( fr_A_0(Wave_Pos_1:Wave_Pos_2,:)));  %选取 Wave_1~Wave_2波长范围内的最大值
         Zmin = min( min( fr_A_0(Wave_Pos_1:Wave_Pos_2,:)));  %选取 Wave_1~Wave_2波长范围内的最小值
         set(gca,'CLim',[Zmin Zmax]);  %设置color bar 显示范围
      
      set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);%这句是将线宽改为2
      set(gca,'Ytick',[0.1, 1, 10, 100, 1000 ]);
      set(gca,'yscale','log');
      set(gca,'Xtick',[400:100:770]);
      set(gcf,'Position',[100 100 400 320]);%这句是设置绘图的大小，不需要到word里再调整大小。我给的参数，图的大小是7cm
      colorbar('position',[0.82 0.17 0.035 0.75]); %设置彩色条的位置和大小
      
          print([num2str(file(n).name),'.tif'] ,'-dtiffn','-r300');
      end   
    
      %%提取deltaA光谱信息
         Delay = [-0.2, 0.5, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];
         if(1)
                  %Delay1
         Delay_1 = Delay (1,1);
         [~,Delay_1_1]=min(abs(fr_y_0(:) - Delay_1));               % 寻找最靠近Delay_1时间的位置        
         Spec_1 = fr_A_1(Delay_1_1,:); Spec_1 = [Delay_1, fr_y_0(1,Delay_1_1), Spec_1];  % 寻找最对应Delay_1时间的光谱    
                  %Delay2
         Delay_2 = Delay (1,2);
         [~,Delay_2_1]=min(abs(fr_y_0(:) - Delay_2));               % 寻找最靠近Delay_1时间的位置        
         Spec_2 = fr_A_1(Delay_2_1,:); Spec_2 = [Delay_2, fr_y_0(1,Delay_2_1), Spec_2];  % 寻找最对应Delay_1时间的光谱   
                  %Delay3
         Delay_3 = Delay (1,3);
         [~,Delay_3_1]=min(abs(fr_y_0(:) - Delay_3));               % 寻找最靠近Delay_1时间的位置        
         Spec_3 = fr_A_1(Delay_3_1,:); Spec_3 = [Delay_3, fr_y_0(1,Delay_3_1), Spec_3];  % 寻找最对应Delay_1时间的光谱   
                  %Delay4
         Delay_4 = Delay (1,4);
         [~,Delay_4_1]=min(abs(fr_y_0(:) - Delay_4));               % 寻找最靠近Delay_1时间的位置        
         Spec_4 = fr_A_1(Delay_1_1,:); Spec_4 = [Delay_4, fr_y_0(1,Delay_4_1), Spec_4];  % 寻找最对应Delay_1时间的光谱   
                  %Delay5
         Delay_5 = Delay (1,5);
         [~,Delay_5_1]=min(abs(fr_y_0(:) - Delay_5));               % 寻找最靠近Delay_1时间的位置        
         Spec_5 = fr_A_1(Delay_5_1,:); Spec_5 = [Delay_5, fr_y_0(1,Delay_5_1), Spec_5];  % 寻找最对应Delay_1时间的光谱   
                  %Delay6
         Delay_6 = Delay (1,6);
         [~,Delay_6_1]=min(abs(fr_y_0(:) - Delay_6));               % 寻找最靠近Delay_1时间的位置        
         Spec_6 = fr_A_1(Delay_6_1,:); Spec_6 = [Delay_6, fr_y_0(1,Delay_6_1), Spec_6];  % 寻找最对应Delay_1时间的光谱   
                  %Delay7
         Delay_7 = Delay (1,7);
         [~,Delay_7_1]=min(abs(fr_y_0(:) - Delay_7));               % 寻找最靠近Delay_1时间的位置        
         Spec_7 = fr_A_1(Delay_7_1,:); Spec_7 = [Delay_7, fr_y_0(1,Delay_7_1), Spec_7];  % 寻找最对应Delay_1时间的光谱   
                  %Delay8
         Delay_8 = Delay (1,8);
         [~,Delay_8_1]=min(abs(fr_y_0(:) - Delay_8));               % 寻找最靠近Delay_1时间的位置        
         Spec_8 = fr_A_1(Delay_8_1,:); Spec_8 = [Delay_8, fr_y_0(1,Delay_8_1), Spec_8];  % 寻找最对应Delay_1时间的光谱   
                  %Delay9
         Delay_9 = Delay (1,9);
         [~,Delay_9_1]=min(abs(fr_y_0(:) - Delay_9));               % 寻找最靠近Delay_1时间的位置        
         Spec_9 = fr_A_1(Delay_9_1,:); Spec_9 = [Delay_9, fr_y_0(1,Delay_9_1), Spec_9];  % 寻找最对应Delay_1时间的光谱  
                  %Delay10
         Delay_10 = Delay (1,10);
         [~,Delay_10_1]=min(abs(fr_y_0(:) - Delay_10));               % 寻找最靠近Delay_1时间的位置        
         Spec_10 = fr_A_1(Delay_10_1,:); Spec_10 = [Delay_10, fr_y_0(1,Delay_10_1), Spec_10];  % 寻找最对应Delay_1时间的光谱           
                  %Delay11
         Delay_11 = Delay (1,11);
         [~,Delay_11_1]=min(abs(fr_y_0(:) - Delay_11));               % 寻找最靠近Delay_1时间的位置        
         Spec_11 = fr_A_1(Delay_11_1,:); Spec_11 = [Delay_11, fr_y_0(1,Delay_11_1), Spec_11];  % 寻找最对应Delay_1时间的光谱
                  %Delay12
         Delay_12 = Delay (1,12);
         [~,Delay_12_1]=min(abs(fr_y_0(:) - Delay_12));               % 寻找最靠近Delay_1时间的位置        
         Spec_12 = fr_A_1(Delay_12_1,:); Spec_12 = [Delay_12, fr_y_0(1,Delay_12_1), Spec_12];  % 寻找最对应Delay_1时间的光谱  
                  %Delay13
         Delay_13 = Delay (1,13);
         [~,Delay_13_1]=min(abs(fr_y_0(:) - Delay_13));               % 寻找最靠近Delay_1时间的位置        
         Spec_13 = fr_A_1(Delay_13_1,:); Spec_13 = [Delay_13, fr_y_0(1,Delay_13_1), Spec_13];  % 寻找最对应Delay_1时间的光谱  
         end
         Wavelength = [0,0,fr_x_0'];
         Spectra = [Wavelength;Spec_1;Spec_2;Spec_3;Spec_4;Spec_5;Spec_6;Spec_7;Spec_8;Spec_9;Spec_10;Spec_11;Spec_12;Spec_13];
         Spectra_1 = Spectra';
         save(file(n).name,'Spectra_1','-ascii');
         
          
         %Zmax = max( max( fr_A_0(Wave_Pos_1:Wave_Pos_2,:)));  %选取 Wave_1~Wave_2波长范围内的最大值
         %Zmin = min( min( fr_A_0(Wave_Pos_1:Wave_Pos_2,:)));  %选取 Wave_1~Wave_2波长范围内的最小值
         %set(gca,'CLim',[Zmin Zmax]);  %设置color bar 显示范围
      
  end
end
        

function ddata = interpLocation(dog_imgs,height,width,octv,intvl,x,y,img_border,contr_thr,max_interp_steps)
%% 重写一遍此处要用的全局变量
global init_sigma;
global intvls;

%% 改进关键点位置的精度
i = 1;
while (i <= max_interp_steps)    % 迭代max_interp_steps次（5次）
    grad_D = deriv3D(intvl,x,y);
    H = hessian3D(intvl,x,y);
    x_hat = - inv(H)*grad_D;
    % 所有维度均小于0.5时才符合要求
    if (abs(x_hat(1)) <= 0.5 && abs(x_hat(2)) <= 0.5 && abs(x_hat(3)) <= 0.5)
        break;
    end
    % 改变样本点的位置
    x = x + round(x_hat(1));
    y = y + round(x_hat(2));
    intvl = intvl + round(x_hat(3));
    % 超出边界的点不是关键点
    if (intvl < 2 || intvl > intvls+1 || x <= img_border || y <= img_border ...
            || x > height-img_border || y > width-img_border)
        ddata = [];
        return;
    end
    i = i+1;
end
% 迭代max_interp_steps次仍然不收敛的点不是关键点
if (i > max_interp_steps)
    ddata = [];
    return;
end
% 消除边缘响应（曲折度之比过小，可能是边缘点）
contr = dog_imgs(x,y,intvl) + 0.5*grad_D'*x_hat;
if (abs(contr) < contr_thr)
    ddata = [];
    return;
end
% 返回找到的符合要求的极值点的信息
ddata.x = x;
ddata.y = y;
ddata.octv = octv;
ddata.intvl = intvl;
ddata.x_hat = x_hat;
ddata.scl_octv = init_sigma * 2^((intvl+x_hat(3)-1) / intvls);

%% 求样本点处的梯度
function grad = deriv3D(intvl,x,y)
    dx = (dog_imgs(x+1,y,intvl) - dog_imgs(x-1,y,intvl))/2;
    dy = (dog_imgs(x,y+1,intvl) - dog_imgs(x,y-1,intvl))/2;
    ds = (dog_imgs(x,y,intvl+1) - dog_imgs(x,y,intvl-1))/2;
    grad = [dx;dy;ds];
end

%% 求样本点处的黑塞矩阵
function hessian = hessian3D(intvl,x,y)
    dxx = dog_imgs(x+1,y,intvl) + dog_imgs(x-1,y,intvl) - 2 * dog_imgs(x,y,intvl);
    dyy = dog_imgs(x,y+1,intvl) + dog_imgs(x,y-1,intvl) - 2 * dog_imgs(x,y,intvl);
    dss = dog_imgs(x,y,intvl+1) + dog_imgs(x,y,intvl-1) - 2 * dog_imgs(x,y,intvl);
    dxy = (dog_imgs(x+1,y+1,intvl) + dog_imgs(x-1,y-1,intvl) ...
        - (dog_imgs(x+1,y-1,intvl) + dog_imgs(x-1,y+1,intvl))) / 4;
    dxs = (dog_imgs(x+1,y,intvl+1) + dog_imgs(x-1,y,intvl-1) ...
        - (dog_imgs(x+1,y,intvl-1) + dog_imgs(x-1,y,intvl+1))) / 4;
    dys = (dog_imgs(x,y+1,intvl+1) + dog_imgs(x,y-1,intvl-1) ...
        - (dog_imgs(x,y-1,intvl+1) + dog_imgs(x,y+1,intvl-1))) / 4;
    hessian = [dxx,dxy,dxs;dxy,dyy,dys;dxs,dys,dss];
end
end    % 使dog_imgs为全局变量
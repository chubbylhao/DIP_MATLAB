function feat_index = addOriFeatures(ddata_index,feat_index,ddata,hist,n,ori_peak_ratio)
%% 产生关键点方向
global features;
global init_sigma;
global intvls;
omax = dominantOri(hist,n);
for i = 1:n
    if (i==1)
        l = n;
        r = 2;
    elseif (i==n)
        l = n-1;
        r = 1;
    else
        l = i-1;
        r = i+1;
    end
    if (hist(i) > hist(l) && hist(i) > hist(r) && hist(i) >= ori_peak_ratio*omax)
        bin = i + interp_hist_peak(hist(l),hist(i),hist(r));
        if ( bin - 1 <= 0 )
            bin = bin + n;
        elseif ( bin - 1 > n )
            bin = bin - n;
        end
        accu_intvl = ddata.intvl + ddata.x_hat(3);
        features(feat_index).ddata_index = ddata_index;
        % 第一组两倍大小（应转换至原图大小才能得出正确的坐标位置）
        features(feat_index).x = (ddata.x + ddata.x_hat(1))*2^(ddata.octv-2);
        features(feat_index).y = (ddata.y + ddata.x_hat(2))*2^(ddata.octv-2);
        features(feat_index).scl = init_sigma * 2^(ddata.octv-2 + (accu_intvl-1)/intvls);        
        features(feat_index).ori = (bin-1)/n*2*pi - pi;
        feat_index = feat_index + 1;
    end
end
end

%% 方向梯度最大值
function omax = dominantOri(hist,n)
omax = hist(1);
for i = 2:n
    if(hist(i) > omax)
        omax = hist(i);
    end
end
end

%% 抛物插值
function position = interp_hist_peak(l,c,r)
position = 0.5*(l-r)/(l-2*c+r);
end
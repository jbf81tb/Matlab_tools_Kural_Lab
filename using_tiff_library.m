img = uint32(1000000*sdmap{17});
t = Tiff('tmp.tif','w');
t.setTag('Photometric',Tiff.Photometric.MinIsBlack);
t.setTag('BitsPerSample',32);
t.setTag('ImageLength',size(img,1));
t.setTag('ImageWidth',size(img,2));
t.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
t.write(img)
t.close();
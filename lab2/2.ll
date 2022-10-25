; Preheader:
  br label %3

; Loop:
3:                                                ; preds = %1, %3
  %.010 = phi i64 [ 0, %1 ], [ %7, %3 ]
  %.089 = phi i32 [ 0, %1 ], [ %6, %3 ]
  %4 = getelementptr inbounds i32, i32* %0, i64 %.010
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = add nsw i32 %5, %.089
  %7 = add nuw nsw i64 %.010, 1
  %exitcond = icmp ne i64 %7, 1024
  br i1 %exitcond, label %3, label %2, !llvm.loop !6

; Exit blocks
2:                                                ; preds = %3
  %.lcssa = phi i32 [ %6, %3 ]
  ret i32 %.lcssa
*** IR Dump After Unroll loops ***
; Preheader:
  br label %3

; Loop:
3:                                                ; preds = %1, %3
  %.010 = phi i64 [ 0, %1 ], [ %7, %3 ]
  %.089 = phi i32 [ 0, %1 ], [ %6, %3 ]
  %4 = getelementptr inbounds i32, i32* %0, i64 %.010
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = add nsw i32 %5, %.089
  %7 = add nuw nsw i64 %.010, 1
  %exitcond = icmp ne i64 %7, 1024
  br i1 %exitcond, label %3, label %2, !llvm.loop !6

; Exit blocks
2:                                                ; preds = %3
  %.lcssa = phi i32 [ %6, %3 ]
  ret i32 %.lcssa
*** IR Dump Before Unroll loops ***
; Preheader:
vector.ph:
  br label %vector.body

; Loop:
vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %5, %vector.body ]
  %vec.phi11 = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %6, %vector.body ]
  %1 = getelementptr inbounds i32, i32* %0, i64 %index
  %2 = bitcast i32* %1 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %2, align 4, !tbaa !2
  %3 = getelementptr inbounds i32, i32* %1, i64 4
  %4 = bitcast i32* %3 to <4 x i32>*
  %wide.load12 = load <4 x i32>, <4 x i32>* %4, align 4, !tbaa !2
  %5 = add <4 x i32> %wide.load, %vec.phi
  %6 = add <4 x i32> %wide.load12, %vec.phi11
  %index.next = add i64 %index, 8
  %7 = icmp eq i64 %index.next, 1024
  br i1 %7, label %middle.block, label %vector.body, !llvm.loop !6

; Exit blocks
middle.block:                                     ; preds = %vector.body
  %.lcssa13 = phi <4 x i32> [ %5, %vector.body ]
  %.lcssa = phi <4 x i32> [ %6, %vector.body ]
  %bin.rdx = add <4 x i32> %.lcssa, %.lcssa13
  %8 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %bin.rdx)
  ret i32 %8
*** IR Dump After Unroll loops ***
; Preheader:
vector.ph:
  br label %vector.body

; Loop:
vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next.3, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %23, %vector.body ]
  %vec.phi11 = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %24, %vector.body ]
  %1 = getelementptr inbounds i32, i32* %0, i64 %index
  %2 = bitcast i32* %1 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %2, align 4, !tbaa !2
  %3 = getelementptr inbounds i32, i32* %1, i64 4
  %4 = bitcast i32* %3 to <4 x i32>*
  %wide.load12 = load <4 x i32>, <4 x i32>* %4, align 4, !tbaa !2
  %5 = add <4 x i32> %wide.load, %vec.phi
  %6 = add <4 x i32> %wide.load12, %vec.phi11
  %index.next = add nuw nsw i64 %index, 8
  %7 = getelementptr inbounds i32, i32* %0, i64 %index.next
  %8 = bitcast i32* %7 to <4 x i32>*
  %wide.load.1 = load <4 x i32>, <4 x i32>* %8, align 4, !tbaa !2
  %9 = getelementptr inbounds i32, i32* %7, i64 4
  %10 = bitcast i32* %9 to <4 x i32>*
  %wide.load12.1 = load <4 x i32>, <4 x i32>* %10, align 4, !tbaa !2
  %11 = add <4 x i32> %wide.load.1, %5
  %12 = add <4 x i32> %wide.load12.1, %6
  %index.next.1 = add nuw nsw i64 %index.next, 8
  %13 = getelementptr inbounds i32, i32* %0, i64 %index.next.1
  %14 = bitcast i32* %13 to <4 x i32>*
  %wide.load.2 = load <4 x i32>, <4 x i32>* %14, align 4, !tbaa !2
  %15 = getelementptr inbounds i32, i32* %13, i64 4
  %16 = bitcast i32* %15 to <4 x i32>*
  %wide.load12.2 = load <4 x i32>, <4 x i32>* %16, align 4, !tbaa !2
  %17 = add <4 x i32> %wide.load.2, %11
  %18 = add <4 x i32> %wide.load12.2, %12
  %index.next.2 = add nuw nsw i64 %index.next.1, 8
  %19 = getelementptr inbounds i32, i32* %0, i64 %index.next.2
  %20 = bitcast i32* %19 to <4 x i32>*
  %wide.load.3 = load <4 x i32>, <4 x i32>* %20, align 4, !tbaa !2
  %21 = getelementptr inbounds i32, i32* %19, i64 4
  %22 = bitcast i32* %21 to <4 x i32>*
  %wide.load12.3 = load <4 x i32>, <4 x i32>* %22, align 4, !tbaa !2
  %23 = add <4 x i32> %wide.load.3, %17
  %24 = add <4 x i32> %wide.load12.3, %18
  %index.next.3 = add nuw nsw i64 %index.next.2, 8
  %25 = icmp eq i64 %index.next.3, 1024
  br i1 %25, label %middle.block, label %vector.body, !llvm.loop !6

; Exit blocks
middle.block:                                     ; preds = %vector.body
  %.lcssa13 = phi <4 x i32> [ %23, %vector.body ]
  %.lcssa = phi <4 x i32> [ %24, %vector.body ]
  %bin.rdx = add <4 x i32> %.lcssa, %.lcssa13
  %26 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %bin.rdx)
  ret i32 %26
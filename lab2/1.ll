; Function Attrs: norecurse nounwind readonly uwtable
define dso_local i32 @sum(i32* nocapture readonly %0) local_unnamed_addr #0 {
  br label %3

2:                                                ; preds = %3
  %.lcssa = phi i32 [ %6, %3 ]
  ret i32 %.lcssa

3:                                                ; preds = %1, %3
  %.010 = phi i64 [ 0, %1 ], [ %7, %3 ]
  %.089 = phi i32 [ 0, %1 ], [ %6, %3 ]
  %4 = getelementptr inbounds i32, i32* %0, i64 %.010
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = add nsw i32 %5, %.089
  %7 = add nuw nsw i64 %.010, 1
  %exitcond.not = icmp eq i64 %7, 1024
  br i1 %exitcond.not, label %2, label %3, !llvm.loop !6
}

; Function Attrs: norecurse nounwind readonly uwtable
define dso_local i32 @sum(i32* nocapture readonly %0) local_unnamed_addr #0 {
  br i1 false, label %scalar.ph, label %vector.ph

vector.ph:                                        ; preds = %1
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %10, %vector.body ]
  %vec.phi11 = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %11, %vector.body ]
  %2 = add i64 %index, 0
  %3 = add i64 %index, 4
  %4 = getelementptr inbounds i32, i32* %0, i64 %2
  %5 = getelementptr inbounds i32, i32* %0, i64 %3
  %6 = getelementptr inbounds i32, i32* %4, i32 0
  %7 = bitcast i32* %6 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %7, align 4, !tbaa !2
  %8 = getelementptr inbounds i32, i32* %4, i32 4
  %9 = bitcast i32* %8 to <4 x i32>*
  %wide.load12 = load <4 x i32>, <4 x i32>* %9, align 4, !tbaa !2
  %10 = add <4 x i32> %wide.load, %vec.phi
  %11 = add <4 x i32> %wide.load12, %vec.phi11
  %index.next = add i64 %index, 8
  %12 = icmp eq i64 %index.next, 1024
  br i1 %12, label %middle.block, label %vector.body, !llvm.loop !6

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <4 x i32> %11, %10
  %13 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %bin.rdx)
  %cmp.n = icmp eq i64 1024, 1024
  br i1 %cmp.n, label %14, label %scalar.ph

scalar.ph:                                        ; preds = %1, %middle.block
  %bc.resume.val = phi i64 [ 1024, %middle.block ], [ 0, %1 ]
  %bc.merge.rdx = phi i32 [ 0, %1 ], [ %13, %middle.block ]
  br label %15

14:                                               ; preds = %middle.block, %15
  %.lcssa = phi i32 [ %18, %15 ], [ %13, %middle.block ]
  ret i32 %.lcssa

15:                                               ; preds = %scalar.ph, %15
  %.010 = phi i64 [ %bc.resume.val, %scalar.ph ], [ %19, %15 ]
  %.089 = phi i32 [ %bc.merge.rdx, %scalar.ph ], [ %18, %15 ]
  %16 = getelementptr inbounds i32, i32* %0, i64 %.010
  %17 = load i32, i32* %16, align 4, !tbaa !2
  %18 = add nsw i32 %17, %.089
  %19 = add nuw nsw i64 %.010, 1
  %exitcond.not = icmp eq i64 %19, 1024
  br i1 %exitcond.not, label %14, label %15, !llvm.loop !9
}